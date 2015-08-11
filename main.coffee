###!
# @package Interactive Forward Bot
# @author Hasin Hayder <hasin@leevio.com>
# @license MIT
###
# readline for IO
readline = require 'readline'
rl = readline.createInterface
  input: process.stdin
  output: process.stdout
# sleep(for sleep ? O.o IDK)
# sleep = require 'sleep'
# Parse CSON file, i.e. the questions
cson = require 'cson'
q = cson.load 'questions.cson'
# for fancy logging colors
chalk = require 'chalk'
# emojis :D
emoji = require 'node-emoji'
  .emoji
# psych colors cyan log
iLogz = (text, danger = false) ->
  color = unless danger then chalk.cyan else chalk.magenta
  face = unless danger then chalk.yellow emoji.blush else chalk.red emoji.angry
  console.log color "#{text} #{face}"
# some loop index, global scope to denote static I assume
i = 0
shouldgo = true
# The first question, now I understand the i
qstn = q.questions[i]
# Output the question
iLogz qstn.q
# take input answer
do rl.question
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
    # sleep.sleep 1
    iLogz q.profanityexit[randomAnsIndex], true
    do process.exit
  #first check if the answer matches any link
  if qstn.link
    linked = false
    linked = qstn.link.filter (n) ->
      line.indexOf(n) isnt -1
    if linked.length > 0
      if qstn.linkans
        iLogz qstn.linkans
        shouldProcessNo = false
      # sleep.sleep 1
  #ok so if there was no match with a linked ans, maybe it's a negative reply?
  if qstn.no and shouldProcessNo
    linked = false
    linked = qstn.no.filter (n) ->
      line.indexOf(n) isnt -1
    if linked.length > 0
      if qstn.noq
        qstn = qstn.noq
        # sleep.sleep 1
        shouldgo = false
        #link this noq question with the standard question loop
      else if qstn.linkans
        iLogz qstn.linkans
        do process.exit
      else
        do process.exit
  #noq was not linked. so let's go as usually
  if shouldgo
    i++
    if i > q.questions.length
      do process.exit
    qstn = q.questions[i]
  if qstn
    # sleep.usleep 250000
    #breath for a quarter second
    iLogz qstn.q
    #if this a dead end, say good bye
    if not qstn.no and not qstn.link
      do process.exit
  else
    #no more questions, phew!
    do process.exit
  return
