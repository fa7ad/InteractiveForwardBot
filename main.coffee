###!
# @package Interactive Forward Bot
# @author Hasin Hayder <hasin@leevio.com>
# @license MIT
###
# realine for IO
readline = require 'readline'
# sleep(for sleep ? O.o IDK)
sleep = require 'sleep'
# To parse CSON files, i.e. the questions
cson = require 'cson'
# load the questions
q = cson.load 'questions.cson'
# for fancy logging colors
chalk = require 'chalk'
# psych awesome cyan log
iLogz = (text, danger = false) ->
  color = unless danger then chalk.cyan else chalk.magenta
  console.log color "#{text}"
# set up a readline interface
rl = readline.createInterface
  input: process.stdin
  output: process.stdout
# some loop index, only @hasinhayder knows why its here(dirty global scope?)
i = 0
shouldgo = true
qstn = q.questions[i]
iLogz qstn.q
rl.question()
rl.on 'line', (line) ->
  shouldgo = true
  shouldProcessNo = true
  line = line.trim().toLowerCase()
  linked = false
  #profanity check - let's say bye to the fucknuts
  linked = q.profanity.filter (n) ->
    line.indexOf(n) != -1
  #this user is definitely a fucknut, say goodbye
  if linked.length > 0
    randomAnsIndex = Math.floor Math.random() * q.profanityexit.length
    sleep.sleep 1
    iLogz q.profanityexit[randomAnsIndex], true
    process.exit()
  #first check if the answer matches any link
  if qstn.link
    linked = false
    linked = qstn.link.filter((n) ->
      line.indexOf(n) != -1
    )
    if linked.length > 0
      if qstn.linkans
        iLogz qstn.linkans
        shouldProcessNo = false
      sleep.sleep 1
  #ok so if there was no match with a linked ans, maybe it's a negative reply?
  if qstn.no and shouldProcessNo
    linked = false
    linked = qstn.no.filter((n) ->
      line.indexOf(n) != -1
    )
    if linked.length > 0
      if qstn.noq
        qstn = qstn.noq
        sleep.sleep 1
        shouldgo = false
        #link this noq question with the standard question loop
      else if qstn.linkans
        iLogz qstn.linkans
        process.exit()
      else
        process.exit()
  #noq was not linked. so let's go as usually
  if shouldgo == true
    i++
    if i > q.questions.length
      process.exit()
    qstn = q.questions[i]
  if qstn
    sleep.usleep 250000
    #breath for a quarter second
    iLogz qstn.q
    #if this a dead end, say good bye
    if !qstn.no and !qstn.link
      process.exit()
  else
    #no more questions, phew!
    process.exit()
  return
