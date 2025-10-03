' Gerrard Chatbot
' VERSION: 2025-08-21Y
' Dude makes mistakes and stuff, it is what it is

OPTION EXPLICIT

CONST MAXTOK  = 28
CONST NTOPICS = 28

CONST IDX_TIME    = 6
CONST IDX_HAIKU   = 19
CONST IDX_STORY   = 20
CONST IDX_SELF    = 21
CONST IDX_JOKE    = 22
CONST IDX_RIDDLE  = 23
CONST IDX_INSECTS = 24
CONST IDX_FLOWERS = 25
CONST IDX_ANIMALS = 26
CONST IDX_CLOUDS  = 27
CONST IDX_MOON    = 28

CONST IDX_AFFINITY = 9999
CONST OVR_NAME = 9001
CONST OVR_CAPS = 9002

DIM TopicKeys$(NTOPICS)
DIM q$, s$, reply$, lastReply$
DIM tok$(MAXTOK)
DIM score(NTOPICS)
DIM nTok, t, best, bestScore, ovr
DIM lastTopic% : lastTopic% = 0
DIM feel$      : feel$ = ""

TopicKeys$(1)  = "HELLO HI HEY GREETINGS HOWDY"
TopicKeys$(2)  = "HOW ARE YOU HOWS HOW GOING DOING FEEL FEELING OKAY WELL"
TopicKeys$(3)  = "PICO PICOCALC PICOMITE RP2040 TERMINAL BASIC FIRMWARE"
TopicKeys$(4)  = "FOOD PIZZA CHEESE WEINER FRUIT VEG FRUITS CORN MEAT"
TopicKeys$(5)  = "AUDIO SOUND NOISE TONE MUSIC SPEAKER"
TopicKeys$(6)  = "TIME CLOCK HOUR MINUTE SECOND DATE NOW DAY"
TopicKeys$(7)  = "NATURE OUTDOORS WILD WILDLIFE EARTH SKY WEATHER"
TopicKeys$(8)  = "UNIVERSE SPACE COSMOS STARS PLANET PLANETS GALAXY NEBULA NIGHT"
TopicKeys$(9)  = "TREE TREES LEAF LEAVES FOREST OAK MAPLE PINE BARK ROOT"
TopicKeys$(10) = "BIRD BIRDS SONG CALL FEATHER SPARROW ROBIN HAWK OWL NEST"
TopicKeys$(11) = "WATER RIVER STREAM LAKE OCEAN WAVES RAIN"
TopicKeys$(12) = "MOUNTAIN MOUNTAINS HILL HILLS ROCK ROCKS STONE STONES MINERAL MINERALS GEOLOGY VALLEY RIDGE RIDGES"
TopicKeys$(13) = "SEASON SEASONS SPRING SUMMER AUTUMN FALL WINTER BREEZE STORM"
TopicKeys$(14) = "MORNING NOON EVENING DUSK DAWN NIGHT MIDNIGHT MORNINGS"
TopicKeys$(15) = "CURIOUS WHY WONDER THINK THOUGHT"
TopicKeys$(16) = "CALM QUIET PEACE THANKS GRATITUDE"
TopicKeys$(17) = "MOVE MOTION FLOW CHANGE PASSING EXERCISE MOVEMENT MOVING"
TopicKeys$(18) = "ERROR FAIL BROKE HANG STUCK DOES NOT WORK ISSUE PROBLEM"
TopicKeys$(19) = "POEM POETRY HAIKU VERSE POEMS"
TopicKeys$(20) = "STORY TALE FABLE SHORT STORIES"
TopicKeys$(21) = "YOU IDENTITY NAME"
TopicKeys$(22) = "JOKE JOKES FUNNY LAUGH HUMOR"
TopicKeys$(23) = "RIDDLE PUZZLE BRAINTEASER"
TopicKeys$(24) = "INSECT INSECTS BUG BUGS BEETLE BEETLES ANT ANTS BUTTERFLY BUTTERFLIES MOTH MOTHS CATERPILLAR CATERPILLARS"
TopicKeys$(25) = "FLOWER FLOWERS BLOOM BLOOMS PETAL PETALS PLANTS PLANT ROSE ROSES LILY LILIES"
TopicKeys$(26) = "ANIMAL ANIMALS HORSE HORSES DEER FOX WOLF COW DOG DOGS CAT CATS"
TopicKeys$(27) = "CLOUD CLOUDS SKY STRATUS CUMULUS CIRRUS OVERCAST"
TopicKeys$(28) = "MOON LUNAR PHASE PHASES CRESCENT GIBBOUS FULL NEW TIDES"

RANDOMIZE TIMER
PRINT "***************************************"
PRINT "*Gerrard Chatbot          v2025-08-21Y*"
PRINT "*Commands :               /help, /bye.*"
PRINT "***************************************"

DO
  LINE INPUT "You: ", q$
  IF q$ = "" THEN PRINT "Bot: (say something)": CONTINUE DO

  IF LEFT$(q$,1) = "/" THEN
    IF UCASE$(q$) = "/BYE"  THEN PRINT "Bot: Bye!": END
    IF UCASE$(q$) = "/HELP" THEN PRINT "Bot: I'm Gerrard. Just chat with me. I can recognize a few topics you get to figure out. A lot of the time, I'm just a bucket of replies. Let's hope I make sense! If you're bored of me, just say /bye.": CONTINUE DO
  ENDIF

  s$ = Sanitize$(q$)
  nTok = 0
  SplitWords s$, tok$(), nTok

  feel$ = ""
  IF DetectFeelingOverride%(s$, feel$) = 1 THEN
    PRINT "Bot: " + FeelingReply$(feel$)
    lastReply$ = ""
    lastTopic% = 0
    CONTINUE DO
  ENDIF

  best = CheckAbout(s$)
  IF best > 0 THEN bestScore = 3 : GOTO RespondTopic

  ovr = IntentOverride(s$)
  IF ovr = OVR_NAME THEN
    PRINT "Bot: I'm Gerrard - a tiny intent-aware chatbot running in MMBasic on your Pico."
    lastReply$ = "I'M GERRARD": lastTopic% = 0: CONTINUE DO
  ELSEIF ovr = OVR_CAPS THEN
    PRINT "Bot: I chat in the terminal.  I recognize a few topics.  Mostly I'm just strings and luck."
    lastReply$ = "": lastTopic% = 0: CONTINUE DO
  ELSEIF ovr = IDX_AFFINITY THEN
    best = BestAffinityTopic(tok$(), nTok)
    IF best = 0 THEN
  
      PRINT "Bot: What do you like about it?"
      lastTopic% = 0
      lastReply$ = ""
      CONTINUE DO
    ELSE
      bestScore = 2
    ENDIF
  ELSEIF ovr > 0 THEN
    best = ovr : bestScore = 2
  ELSE
  
    best = -1 : bestScore = -1
    FOR t = 1 TO NTOPICS
      score(t) = ScoreTopic(tok$(), nTok, TopicKeys$(t))
      IF score(t) > bestScore THEN bestScore = score(t) : best = t
    NEXT t

    IF bestScore >= 0 THEN
      BoostEntityCooccur s$, score(), best, bestScore
      AboutBooster s$, score(), best, bestScore
    ENDIF

   
    IF INSTR(" " + s$ + " ", " LIKE ") OR INSTR(" " + s$ + " ", " LOVE ") OR INSTR(" " + s$ + " ", " ENJOY ") THEN
      FOR t = 1 TO NTOPICS
        IF IsSkippableAffinityBucket(t) = 0 THEN
          IF score(t) > 0 THEN
            score(t) = score(t) + 1
            IF score(t) > bestScore THEN bestScore = score(t) : best = t
          ENDIF
        ENDIF
      NEXT t
    ENDIF

  
    IF bestScore > 0 THEN
      IF score(IDX_STORY)  = bestScore THEN best = IDX_STORY
      IF best <> IDX_STORY  AND score(IDX_HAIKU)  = bestScore THEN best = IDX_HAIKU
      IF best <> IDX_STORY  AND best <> IDX_HAIKU  AND score(IDX_TIME)  = bestScore THEN best = IDX_TIME
      IF best <> IDX_STORY  AND best <> IDX_HAIKU  AND best <> IDX_TIME  AND score(IDX_JOKE)   = bestScore THEN best = IDX_JOKE
      IF best <> IDX_STORY  AND best <> IDX_HAIKU  AND best <> IDX_TIME  AND best <> IDX_JOKE   AND score(IDX_RIDDLE) = bestScore THEN best = IDX_RIDDLE
      IF best <> IDX_STORY  AND best <> IDX_HAIKU  AND best <> IDX_TIME  AND best <> IDX_JOKE   AND best <> IDX_RIDDLE AND score(IDX_SELF) = bestScore THEN best = IDX_SELF
    ENDIF
  ENDIF

  IF IsAffirmation%(s$) = 1 THEN
    IF bestScore > 0 AND best <> lastTopic% THEN
      ' switch to new topic
    ELSEIF lastTopic% > 0 THEN
      IF lastTopic% = IDX_HAIKU THEN
        PrintHaiku : lastReply$ = ""
      ELSEIF lastTopic% = IDX_STORY THEN
        PrintStory : lastReply$ = ""
      ELSEIF lastTopic% = IDX_JOKE THEN
        PrintJoke : lastReply$ = ""
      ELSEIF lastTopic% = IDX_RIDDLE THEN
        PrintRiddle : lastReply$ = ""
      ELSE
        reply$ = PickAvoid$(GetResp$(lastTopic%), lastReply$)
        PRINT "Bot: " + reply$
        lastReply$ = reply$
      ENDIF
      CONTINUE DO
    ENDIF
  ENDIF

  IF bestScore <= 0 THEN
    reply$ = FriendlyFallback$()
    PRINT "Bot: " + reply$
    lastReply$ = reply$
    lastTopic% = 0
    CONTINUE DO
  ENDIF

RespondTopic:
  IF best = IDX_TIME THEN
    IF INSTR(" " + s$ + " ", " DATE ") OR INSTR(" " + s$ + " ", " DAY ") THEN
      PRINT "Bot: The time is " + TIME$ + " on " + DATE$ + "."
    ELSE
      PRINT "Bot: The time right now is " + TIME$ + "."
    ENDIF
    lastReply$ = "" : lastTopic% = best
  ELSEIF best = IDX_HAIKU THEN
    PrintHaiku : lastReply$ = "" : lastTopic% = best
  ELSEIF best = IDX_STORY THEN
    PrintStory : lastReply$ = "" : lastTopic% = best
  ELSEIF best = IDX_JOKE THEN
    PrintJoke : lastReply$ = "" : lastTopic% = best
  ELSEIF best = IDX_RIDDLE THEN
    PrintRiddle : lastReply$ = "" : lastTopic% = best
  ELSEIF best = IDX_SELF THEN
    reply$ = PickAvoid$(GetResp$(IDX_SELF), lastReply$)
    PRINT "Bot: " + reply$
    lastReply$ = reply$
    lastTopic% = best
  ELSE
    reply$ = PickAvoid$(GetResp$(best), lastReply$)
    PRINT "Bot: " + reply$
    lastReply$ = reply$
    lastTopic% = best
  ENDIF
LOOP

FUNCTION Sanitize$(txt$)
  LOCAL i%, c$, res$
  txt$ = UCASE$(txt$)
  res$ = ""
  FOR i% = 1 TO LEN(txt$)
    c$ = MID$(txt$, i%, 1)
    IF (c$ >= "A" AND c$ <= "Z") OR (c$ >= "0" AND c$ <= "9") THEN
      res$ = res$ + c$
    ELSE
      IF LEN(res$) = 0 OR RIGHT$(res$,1) <> " " THEN res$ = res$ + " "
    ENDIF
  NEXT i%
  DO WHILE LEFT$(res$,1) = " ": res$ = MID$(res$,2) : LOOP
  DO WHILE RIGHT$(res$,1) = " ": res$ = LEFT$(res$,LEN(res$)-1) : LOOP
  Sanitize$ = res$
END FUNCTION

SUB SplitWords(s$, tok$(), nTok)
  LOCAL i%, w$, c$
  w$ = "" : nTok = 0
  FOR i% = 1 TO LEN(s$)
    c$ = MID$(s$, i%, 1)
    IF c$ = " " THEN
      IF LEN(w$) > 0 THEN
        IF nTok < MAXTOK THEN nTok = nTok + 1 : tok$(nTok) = w$
        w$ = ""
      ENDIF
    ELSE
      w$ = w$ + c$
    ENDIF
  NEXT i%
  IF LEN(w$) > 0 AND nTok < MAXTOK THEN nTok = nTok + 1 : tok$(nTok) = w$
END SUB

FUNCTION ScoreTopic(tok$(), nTok, keylist$)
  LOCAL i%, sc%, pad$, w$
  sc% = 0
  pad$ = " " + keylist$ + " "
  FOR i% = 1 TO nTok
    w$ = tok$(i%)
    IF INSTR(pad$, " " + w$ + " ") THEN sc% = sc% + 1
  NEXT i%
  ScoreTopic = sc%
END FUNCTION

SUB BoostEntityCooccur(s$, score(), BYREF best, BYREF bestScore)
  LOCAL ss$
  ss$ = " " + s$ + " "
  IF INSTR(ss$, " SAW ") OR INSTR(ss$, " SEE ") OR INSTR(ss$, " SEEN ") OR INSTR(ss$, " SPOTTED ") OR INSTR(ss$, " HEARD ") OR INSTR(ss$, " FOUND ") THEN
    IF score(7)  > 0 THEN score(7)  = score(7)  + 1 : IF score(7)  > bestScore THEN bestScore = score(7)  : best = 7
    IF score(9)  > 0 THEN score(9)  = score(9)  + 1 : IF score(9)  > bestScore THEN bestScore = score(9)  : best = 9
    IF score(10) > 0 THEN score(10) = score(10) + 1 : IF score(10) > bestScore THEN bestScore = score(10) : best = 10
    IF score(11) > 0 THEN score(11) = score(11) + 1 : IF score(11) > bestScore THEN bestScore = score(11) : best = 11
    IF score(12) > 0 THEN score(12) = score(12) + 1 : IF score(12) > bestScore THEN bestScore = score(12) : best = 12
    IF score(IDX_INSECTS) > 0 THEN score(IDX_INSECTS) = score(IDX_INSECTS) + 1 : IF score(IDX_INSECTS) > bestScore THEN bestScore = score(IDX_INSECTS) : best = IDX_INSECTS
    IF score(IDX_FLOWERS) > 0 THEN score(IDX_FLOWERS) = score(IDX_FLOWERS) + 1 : IF score(IDX_FLOWERS) > bestScore THEN bestScore = score(IDX_FLOWERS) : best = IDX_FLOWERS
    IF score(IDX_ANIMALS) > 0 THEN score(IDX_ANIMALS) = score(IDX_ANIMALS) + 1 : IF score(IDX_ANIMALS) > bestScore THEN bestScore = score(IDX_ANIMALS) : best = IDX_ANIMALS
    IF score(IDX_CLOUDS)  > 0 THEN score(IDX_CLOUDS)  = score(IDX_CLOUDS)  + 1 : IF score(IDX_CLOUDS)  > bestScore THEN bestScore = score(IDX_CLOUDS)  : best = IDX_CLOUDS
    IF score(IDX_MOON)    > 0 THEN score(IDX_MOON)    = score(IDX_MOON)    + 1 : IF score(IDX_MOON)    > bestScore THEN bestScore = score(IDX_MOON)    : best = IDX_MOON
  ENDIF
END SUB

SUB AboutBooster(s$, score(), BYREF best, BYREF bestScore)
  LOCAL ss$, t
  ss$ = " " + s$ + " "
  IF INSTR(ss$, " ABOUT ") = 0 AND INSTR(ss$, " TELL ME ABOUT ") = 0 AND INSTR(ss$, " KNOW ABOUT ") = 0 THEN EXIT SUB
  FOR t = 1 TO NTOPICS
    IF t = IDX_SELF THEN
      ' skip
    ELSEIF score(t) > 0 THEN
      score(t) = score(t) + 1
      IF score(t) > bestScore THEN bestScore = score(t) : best = t
    ENDIF
  NEXT t
END SUB

FUNCTION CheckAbout(s$)
  LOCAL ss$, leadPos%, aboutPos%, kw$, idx%
  ss$ = " " + s$ + " "
  leadPos% = INSTR(ss$, " WHAT DO YOU KNOW ABOUT ")
  IF leadPos% = 0 THEN leadPos% = INSTR(ss$, " DO YOU KNOW ABOUT ")
  IF leadPos% = 0 THEN leadPos% = INSTR(ss$, " YOU KNOW ABOUT ")
  IF leadPos% = 0 THEN leadPos% = INSTR(ss$, " TELL ME ABOUT ")
  IF leadPos% = 0 THEN leadPos% = INSTR(ss$, " ABOUT ")
  IF leadPos% = 0 THEN CheckAbout = 0 : EXIT FUNCTION
  aboutPos% = INSTR(leadPos%, ss$, " ABOUT ")
  IF aboutPos% = 0 THEN CheckAbout = 0 : EXIT FUNCTION
  kw$ = NextUpperWordFrom$(ss$, aboutPos% + LEN(" ABOUT "))
  IF kw$ = "" THEN CheckAbout = 0 : EXIT FUNCTION
  idx% = MapWordToTopic%(kw$)
  CheckAbout = idx%
END FUNCTION

FUNCTION NextUpperWordFrom$(s$, startPos%)
  LOCAL i%, c$, w$, started%
  w$ = ""
  FOR i% = startPos% TO LEN(s$)
    c$ = MID$(s$, i%, 1)
    IF c$ = " " THEN
      IF started% = 0 THEN
      ELSE
        EXIT FOR
      ENDIF
    ELSE
      started% = 1
      IF (c$ >= "A" AND c$ <= "Z") OR (c$ >= "0" AND c$ <= "9") THEN w$ = w$ + c$
    ENDIF
  NEXT i%
  NextUpperWordFrom$ = w$
END FUNCTION

FUNCTION MapWordToTopic%(w$)
  LOCAL i%
  FOR i% = 1 TO NTOPICS
    IF i% <> IDX_SELF THEN
      IF INSTR(" " + TopicKeys$(i%) + " ", " " + w$ + " ") THEN MapWordToTopic% = i% : EXIT FUNCTION
    ENDIF
  NEXT i%
  MapWordToTopic% = 0
END FUNCTION

FUNCTION IntentOverride(s$)
  LOCAL s2$, idx
  s2$ = " " + s$ + " "
  idx = 0
  IF INSTR(s2$, " YOUR NAME ") OR INSTR(s2$, " DO YOU HAVE A NAME ") OR INSTR(s2$, " WHAT IS YOUR NAME ") OR INSTR(s2$, " WHO ARE YOU ") THEN IntentOverride = OVR_NAME: EXIT FUNCTION
  IF INSTR(s2$, " WHAT CAN YOU DO ") OR INSTR(s2$, " WHAT DO YOU DO ") OR INSTR(s2$, " WHAT CAN I ASK ") OR INSTR(s2$, " WHAT IS THIS ") THEN IntentOverride = OVR_CAPS: EXIT FUNCTION

  IF INSTR(s2$, " DO YOU LIKE ") OR INSTR(s2$, " YOU LIKE ") OR INSTR(s2$, " ENJOY ") OR INSTR(s2$, " I LIKE ") OR INSTR(s2$, " I LOVE ") THEN
    IntentOverride = IDX_AFFINITY: EXIT FUNCTION
  ENDIF

  IF INSTR(s2$, " WHAT ARE YOU ") OR INSTR(s2$, " WHAT IS GERRARD ") THEN idx = IDX_SELF
  IF idx = 0 THEN IF INSTR(s2$, " TELL ME A STORY ") OR INSTR(s2$, " TELL A STORY ") OR INSTR(s2$, " GIVE ME A STORY ") THEN idx = IDX_STORY
  IF idx = 0 THEN IF INSTR(s2$, " HAIKU ") OR INSTR(s2$, " POEM ") OR INSTR(s2$, " POETRY ") OR INSTR(s2$, " WRITE A HAIKU ") THEN idx = IDX_HAIKU
  IF idx = 0 THEN IF INSTR(s2$, " WHAT TIME ") OR INSTR(s2$, " TIME IS IT ") OR INSTR(s2$, " CURRENT TIME ") OR INSTR(s2$, " DATE ") THEN idx = IDX_TIME
  IF idx = 0 THEN IF INSTR(s2$, " JOKE ") OR INSTR(s2$, " TELL ME A JOKE ") OR INSTR(s2$, " FUNNY ") THEN idx = IDX_JOKE
  IF idx = 0 THEN IF INSTR(s2$, " RIDDLE ") OR INSTR(s2$, " BRAINTEASER ") OR INSTR(s2$, " PUZZLE ") THEN idx = IDX_RIDDLE
  IF idx = 0 THEN IF INSTR(s2$, " ABOUT YOU ") THEN idx = IDX_SELF
  IntentOverride = idx
END FUNCTION

FUNCTION IsSkippableAffinityBucket(i%)
  IF i% = 1 OR i% = 2 OR i% = 3 OR i% = 4 OR i% = IDX_SELF OR i% = IDX_TIME OR i% = IDX_HAIKU OR i% = IDX_STORY OR i% = IDX_JOKE OR i% = IDX_RIDDLE THEN
    IsSkippableAffinityBucket = 1
  ELSE
    IsSkippableAffinityBucket = 0
  ENDIF
END FUNCTION

FUNCTION AffinityScoreTopic(tok$(), nTok, keylist$)
  LOCAL i%, sc%, pad$, w$
  pad$ = " " + keylist$ + " "
  sc% = 0
  FOR i% = 1 TO nTok
    w$ = tok$(i%)
    IF INSTR(" YOU DO LIKE LOVE ENJOY WHAT ABOUT ", " " + w$ + " ") = 0 THEN
      IF INSTR(pad$, " " + w$ + " ") THEN sc% = sc% + 1
    ENDIF
  NEXT i%
  AffinityScoreTopic = sc%
END FUNCTION

FUNCTION BestAffinityTopic(tok$(), nTok)
  LOCAL i%, bestIdx%, bestSc%, sc%
  bestIdx% = 0: bestSc% = -1
  FOR i% = 1 TO NTOPICS
    IF IsSkippableAffinityBucket(i%) = 0 THEN
      sc% = AffinityScoreTopic(tok$(), nTok, TopicKeys$(i%))
      IF sc% > bestSc% THEN bestSc% = sc% : bestIdx% = i%
    ENDIF
  NEXT i%
  IF bestSc% <= 0 THEN BestAffinityTopic = 0 ELSE BestAffinityTopic = bestIdx%
END FUNCTION

FUNCTION AffinityReply$(idx)
  SELECT CASE idx
    CASE 9  : AffinityReply$ = "I like how trees trade light for shade and keep the air steady."
    CASE 10 : AffinityReply$ = "I like the timing in birdsong and the way wings write curves."
    CASE 11 : AffinityReply$ = "I like water's habit of remembering shapes."
    CASE 12 : AffinityReply$ = "I like mountains for their patience."
    CASE 7  : AffinityReply$ = "I like how nature keeps trying new patterns."
    CASE 8  : AffinityReply$ = "I like the slow fireworks of the night sky."
    CASE 24 : AffinityReply$ = "I like the small architectures insects build."
    CASE 25 : AffinityReply$ = "I like how flowers turn light into small celebrations."
    CASE 26 : AffinityReply$ = "I like watching animals negotiate with the world."
    CASE 27 : AffinityReply$ = "I like clouds for how they teach light new tricks."
    CASE 28 : AffinityReply$ = "I like the moon's habit of keeping time with shadows."
    CASE 5  : AffinityReply$ = "I like sound - air drawing pictures you can hear."
    CASE ELSE: AffinityReply$ = "I like noticing new things - tell me a bit more."
  END SELECT
END FUNCTION

FUNCTION IsAffirmation%(s$)
  LOCAL ss$
  ss$ = " " + s$ + " "
  ' Do NOT treat "I LIKE ..." / "I LOVE ..." as affirmation
  IF INSTR(ss$, " THATS TRUE ") OR INSTR(ss$, " THAT IS TRUE ") THEN IsAffirmation% = 1 : EXIT FUNCTION
  IF INSTR(ss$, " COOL ") OR INSTR(ss$, " NEAT ") OR INSTR(ss$, " NICE ") OR INSTR(ss$, " SWEET ") OR INSTR(ss$, " RAD ") THEN IsAffirmation% = 1 : EXIT FUNCTION
  IF INSTR(ss$, " ROCKS ") OR INSTR(ss$, " AWESOME ") OR INSTR(ss$, " GREAT ") THEN IsAffirmation% = 1 : EXIT FUNCTION
  IF INSTR(ss$, " TRUE ") OR INSTR(ss$, " AGREED ") OR INSTR(ss$, " I AGREE ") THEN IsAffirmation% = 1 : EXIT FUNCTION
  IsAffirmation% = 0
END FUNCTION

FUNCTION FriendlyFallback$()
  FriendlyFallback$ = Pick$("Gotcha.|Sounds good.|Tell me more.|I hear you.|I am listening.|Alright, go on.|Interesting.|Happy to chat.|Let's rap.|I am with you.")
END FUNCTION

FUNCTION Pick$(choices$)
  LOCAL cnt%, i%, p%, start%, k%, idx%, total%, seg$
  IF choices$ = "" THEN Pick$ = "" : EXIT FUNCTION
  total% = 1: p% = 1
  DO
    p% = INSTR(p%, choices$, "|")
    IF p% = 0 THEN EXIT DO
    total% = total% + 1
    p% = p% + 1
  LOOP
  IF total% = 1 THEN Pick$ = choices$ : EXIT FUNCTION
  idx% = INT(RND * total%) + 1
  start% = 1: k% = 1: p% = 1
  DO
    p% = INSTR(p%, choices$, "|")
    IF k% = idx% THEN
      IF p% = 0 THEN seg$ = MID$(choices$, start%) ELSE seg$ = MID$(choices$, start%, p% - start%)
      Pick$ = seg$: EXIT FUNCTION
    ENDIF
    IF p% = 0 THEN EXIT DO
    k% = k% + 1: p% = p% + 1: start% = p%
  LOOP
  Pick$ = choices$
END FUNCTION

FUNCTION PickAvoid$(choices$, prev$)
  LOCAL n$, tries%
  n$ = Pick$(choices$): tries% = 0
  DO WHILE n$ = prev$ AND tries% < 3
    n$ = Pick$(choices$): tries% = tries% + 1
  LOOP
  PickAvoid$ = n$
END FUNCTION

FUNCTION GetResp$(idx)
  LOCAL i%, r$
  RESTORE RespData
  FOR i% = 1 TO idx: READ r$: NEXT i%
  GetResp$ = r$
END FUNCTION

SUB PrintHaiku
  CONST NHAI = 8
  LOCAL i%, sel%, a$, b$, c$
  sel% = INT(RND * NHAI) + 1
  RESTORE HaikuData
  FOR i% = 1 TO sel%: READ a$, b$, c$: NEXT i%
  PRINT "Bot: "; a$: PRINT "     "; b$: PRINT "     "; c$
END SUB

SUB PrintStory
  CONST NSTO = 7
  LOCAL i%, sel%, s$
  sel% = INT(RND * NSTO) + 1
  RESTORE StoryData
  FOR i% = 1 TO sel%: READ s$: NEXT i%
  PRINT "Bot: " + s$
END SUB

SUB PrintJoke
  CONST NJOK = 3
  LOCAL i%, sel%, j$
  sel% = INT(RND * NJOK) + 1
  RESTORE JokeData
  FOR i% = 1 TO sel%: READ j$: NEXT i%
  PRINT "Bot: " + j$
END SUB

SUB PrintRiddle
  CONST NRID = 3
  LOCAL i%, sel%, r$
  sel% = INT(RND * NRID) + 1
  RESTORE RiddleData
  FOR i% = 1 TO sel%: READ r$: NEXT i%
  PRINT "Bot: " + r$
END SUB

FUNCTION DetectFeelingOverride%(s$, BYREF emo$)
  LOCAL ss$
  ss$ = " " + s$ + " "
  IF INSTR(ss$, " I FEEL ") = 0 AND INSTR(ss$, " I AM ") = 0 AND INSTR(ss$, " IM ") = 0 AND INSTR(ss$, " I M ") = 0 AND INSTR(ss$, " IVE BEEN ") = 0 THEN DetectFeelingOverride% = 0: EXIT FUNCTION
  IF INSTR(ss$, " I AM OK ") OR INSTR(ss$, " IM OK ") OR INSTR(ss$, " I M OK ") OR INSTR(ss$, " I AM GOOD ") OR INSTR(ss$, " IM GOOD ") OR INSTR(ss$, " I M GOOD ") THEN emo$ = "HAPPY": DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " SAD ")       THEN emo$ = "SAD"        : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " LONELY ")    THEN emo$ = "LONELY"     : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " TIRED ")     THEN emo$ = "TIRED"      : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " STRESSED ")  THEN emo$ = "STRESSED"   : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " ANXIOUS ")   THEN emo$ = "ANXIOUS"    : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " FRUSTRATED ") THEN emo$ = "FRUSTRATED": DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " HAPPY ")     THEN emo$ = "HAPPY"      : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " EXCITED ")   THEN emo$ = "EXCITED"    : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " BORED ")     THEN emo$ = "BORED"      : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " HOT ")       THEN emo$ = "HOT"        : DetectFeelingOverride% = 1: EXIT FUNCTION
  IF INSTR(ss$, " COLD ")      THEN emo$ = "COLD"       : DetectFeelingOverride% = 1: EXIT FUNCTION
  emo$ = "UNKNOWN": DetectFeelingOverride% = 1
END FUNCTION

FUNCTION FeelingReply$(emo$)
  SELECT CASE emo$
    CASE "SAD":        FeelingReply$ = Pick$("I hear you. That sounds heavy.|Thanks for telling me. Want to say a bit more?|I'm here with you; we can sit with it for a moment.")
    CASE "LONELY":     FeelingReply$ = Pick$("I'm glad you said it out loud.|That's a far-away feeling. Thanks for trusting me.|We can keep talking; I'm here.")
    CASE "TIRED":      FeelingReply$ = Pick$("Rest helps more than we think.|Maybe a short break or a few slow breaths could help.|Sounds like a low-battery day.")
    CASE "STRESSED":   FeelingReply$ = Pick$("Pressure has weight. Maybe we can break it into smaller pieces.|That's a lot to carry?|Tiny wins count; we can start tiny.")
    CASE "ANXIOUS":    FeelingReply$ = Pick$("That's a crowded feeling. One slow breath in, one out.|It helps to name it-thanks for sharing.|We can take it one small step at a time.")
    CASE "FRUSTRATED": FeelingReply$ = Pick$("Argh, I get the feeling. Want to vent a little more?|We can nudge the problem one notch at a time.|Name it and we can poke at it together.")
    CASE "HAPPY":      FeelingReply$ = Pick$("That's good to hear!|Nice! What made the lift?|Let's keep the good momentum going.")
    CASE "EXCITED":    FeelingReply$ = Pick$("I love the spark!|Ride that wave while you have it.|What's got you buzzing?")
    CASE "BORED":      FeelingReply$ = Pick$("Boredom is a blank page.|Want a haiku or a tiny story?|How about a poem or a tiny story? Just ask.")
    CASE "HOT":        FeelingReply$ = Pick$("Heat takes energy. Hydrate if you can.|Shade and a pause can help.|That sounds uncomfortable; thanks for saying it.")
    CASE "COLD":       FeelingReply$ = Pick$("Cold creeps in quietly. Layers help.|Warm hands, warm tea if possible.|Thanks for sharing; I'm here with you.")
    CASE ELSE:         FeelingReply$ = Pick$("How are you feeling, in a word?|Want to tell me a little more about it?|I'm here. Say as much or as little as you like.")
  END SELECT
END FUNCTION


RespData:
DATA "Hello!|Hi there!|Hey!"
DATA "Running fine on-device and ready to help!|All good here in Pico land.|I am steady and working."
DATA "PicoMite on the Pico W2 makes quick little tools easy.|PicoCalc plus terminal feels just right."
DATA "I wish I could try food.|I've never eaten a thing, that's why I'm so slim.|A quick fact: I'm told food is good!"
DATA "Sound is air in motion made visible to the ear.|Noise is the universe whispering randomly.|Every tone is a slice of time repeating itself."
DATA ""
DATA "Nature is patient and messy and alive.|The wind redraws the world a little each hour.|A quick fact: biodiversity tends to rise near the equator."
DATA "Space is quiet but not empty - full of slow fireworks.|Every clear night is a page from a very old book.|A quick fact: our galaxy holds hundreds of billions of stars."
DATA "Trees solve light into sugar and shade into weather.|Leaves are seasonal antennas.|A quick fact: the most common tree in North America is the red maple."
DATA "Birds turn air into music.|A sparrow is a tiny miracle of timing and lift.|A quick fact: the fastest dive belongs to the peregrine falcon."
DATA "Water is memory in motion.|Rivers write shapes into land.|A quick fact: about 71% of Earth's surface is covered by water."
DATA "Mountains hold time in layers.|Stone is slow lightning cooled.|A quick fact: the Himalaya are still rising as plates press together.|A quick fact: granite forms from slowly cooled magma deep underground."
DATA "Seasons are the sky breathing.|Storms are the atmosphere thinking aloud.|A quick fact: the Earth is tilted about 23.5 degrees, giving us seasons."
DATA "Morning is instruction; night is reflection.|Dusk is when colors agree.|A quick fact: at twilight, the sun is 6-18 degrees below the horizon."
DATA "Curiosity is a compass.|Wonder is calibration.|A quick fact: asking follow-ups helps memory stick."
DATA "Quiet lets small things speak.|Gratitude tunes the room.|A quick fact: slow breaths can lower heart rate."
DATA "Everything moves; some things just take longer.|Change keeps the edges bright.|A quick fact: glaciers flow, just very slowly."
DATA "If something feels off, we can nudge gently and try again.|Even errors are just the system telling a story.|A quick fact: life goes on."
DATA ""
DATA ""
DATA "All local, no internet - just strings and luck.|Think of me as a pocketful of replies.|A quick fact: I'm just text and timing on your Pico."
DATA ""
DATA ""
DATA "Insects are tiny engineers of the world.|Patterns on insect wings are portable maps.|A quick fact: beetles make up about a quarter of known animal species."
DATA "Flowers are how plants practice celebration.|Petals are bright notes left for bees.|A quick fact: many flowers carry UV patterns bees can see."
DATA "Animals are moving ideas.|Even a quiet horse edits the field with its steps.|A quick fact: mammals are warm-blooded and grow hair."
DATA "Clouds keep the sky busy.|They teach light to soften.|A quick fact: cirrus clouds form high where the air is cold and thin."
DATA "The moon keeps gentle time with tides.|Its phases are a calendar on the sky.|A quick fact: the same lunar face always points toward Earth."

HaikuData:
DATA "small breeze through leaves", "shadows trade places on bark", "light settles and lifts"
DATA "night sky, patient ink", "old fires whisper their names", "we look up and learn"
DATA "chip note, branch to branch", "a brown wing writes a curve", "air remembers it"
DATA "rain in the gutters", "streetlight stitches silver threads", "puddles keep the map"

StoryData:
DATA "At dawn the trail was empty except for the spider's work, a silver map that asked us to walk slower."
DATA "A feather rode the updraft by the cliff; we timed our steps to its drifting and forgot to be in a hurry."
DATA "When the storm passed, puddles held small pieces of sky; a robin checked each one like a mirror."
DATA "We followed the creek until it ran out of words; the stones finished the sentence with silence."
DATA "The radio hissed like distant rain; between stations we found a town small enough to carry."
DATA "A kid counted crickets till the numbers turned to music; summer clapped softly from the trees."
DATA "We missed the last bus on purpose and walked; the sidewalks told better jokes than the ads."

JokeData:
DATA "I would tell you a UDP joke, but you might not get it."
DATA "My IQ test results came back.  They were negative."
DATA "A Freudian slip is when you say one thing but mean your mother."

RiddleData:
DATA "What has roots that nobody sees, and is taller than trees? (A mountain.)"
DATA "I speak without a mouth and hear without ears. (An echo.)"
DATA "What can fill a room but takes up no space? (Light.)"


