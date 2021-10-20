::  pull hook
::  additional pokes: see action:ucal-hook
::  additional scrys: /metadata/[ship] for the current public
::  calendars on [ship].
::
/-  *pull-hook, *resource, ucal-store, ucal-hook, *ucal
/+  pull-hook, default-agent, ucal-util
|%
+$  card  card:agent:gall
::
++  config
  ^-  config:pull-hook
  :*  %ucal-store
      to-subscriber:ucal-store
      %ucal-to-subscriber
      %ucal-push-hook
      0  0
      |
  ==
::
::
+$  state-zero
  $:  entries=(jar entity metadata:ucal-hook)
  ==
::
+$  versioned-state
  $%  [%0 state-zero]
  ==
--
::
::::  state
::
=|  state=versioned-state
::
^-  agent:gall
%-  (agent:pull-hook config)
^-  (pull-hook:pull-hook config)
|_  =bowl:gall
+*  this        .
    def         ~(. (default-agent this %|) bowl)
    dep         ~(. (default:pull-hook this config) bowl)
::
::
++  on-init  on-init:def
++  on-save  !>(~)
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ::  TODO why does using team:title lead to -find.team here?
  ?>  =(our.bowl src.bowl)
  ?+  mark  `this
        %ucal-hook-action
      :_  this
      =/  act=action:ucal-hook  !<(action:ucal-hook vase)
      ?:  ?=([%query-cals *] act)
        =/  pax=path  ~[(scot %p who.act) public-calendars:ucal-hook]
        [%pass `wire`pax %agent [who.act push-hook-name:config] %watch pax]~
      ?:  ?=([%invitation-response *] act)
        ::  scry for the event and the host from the local ucal-store
        =/  ev=event
            .^  event
              %gx
              (scot %p our.bowl)
              %ucal-store
              (scot %da now.bowl)
              %invited-to
              %events
              %specific
              calendar-code.act
              event-code.act
              /noun
            ==
        =/  host=@p
            .^  @p
              %gx
              (scot %p our.bowl)
              %ucal-store
              (scot %da now.bowl)
              %host
              calendar-code.act
              event-code.act
              /noun
            ==
        =/  invr=invitation-reply:ucal-store
            :^    status.act
                calendar-code.act
              event-code.act
            (get-event-invite-hash:ucal-util ev)
        =/  wir=wire  [%invitation-reply [calendar-code event-code ~]:act]
        =/  car=card
            :*  %pass
                wir
                %agent
                [host %ucal-store]
                %poke
                %ucal-invitation-reply
                !>(invr)
            ==
        ~[car]
      !!
    ::
        %noun
      ?>  =(our.bowl src.bowl)
      ?+    q.vase  (on-poke:def mark vase)
          %print-state
        ~&  state
        `this
      ::
          %reset-state
        `this(state *versioned-state)
      ==
    ::
  ==
++  on-agent
  |~  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  `this
      [@p %public-calendars *]
    ::  update metadata on facts, ignore everything else
    ?.  ?=([%fact *] sign)
      `this
    =/  who=@p  `@p`(slav %p `@tas`i.wire)
    =/  cag=cage  cage.sign
    ?>  =(p.cag %ucal-hook-update)
    =/  =update:ucal-hook  !<(update:ucal-hook q.cag)
    ?.  ?=([%metadata *] update)
      !!
    ?>  =(who source.update)
    =.  state  state(entries (~(put by entries.state) who items.update))
    `this
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  pax=path
  ^-  (unit (unit cage))
  ?+    pax  (on-peek:def pax)
      [%x %metadata @p *]
    =/  target=entity  `entity`(slav %p `@tas`i.t.t.pax)
    ?.  (~(has by entries.state) target)
      ~
    ``ucal-metadata+!>((~(get ja entries.state) target))
  ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
++  on-pull-nack
  |=   [=resource =tang]
  ^-  (quip card _this)
  [~ this]
++  on-pull-kick
  |=  =resource
  ^-  (unit path)
  `/
::  NOTE: must be kept in sync with +resource-for-update in ucal-push-hook
::
++  resource-for-update
  |=  =vase
  ^-  (list resource)
  =/  ts=to-subscriber:ucal-store  !<(to-subscriber:ucal-store vase)
  ~[resource.ts]
--
