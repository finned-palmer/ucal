/-  *hora, *ucal, ucal-timezone
|%
::
::
+$  calendar-patch
  $:
    owner=(unit @p)
    =calendar-code
    title=(unit @t)
  ==
::
+$  event-patch
  $:
    =calendar-code
    =event-code
    title=(unit title)
    ::  fields of detail
    desc=(unit (unit @t))
    loc=(unit (unit location))
    description=(unit (unit @t))
    ::
    when=(unit moment)
    era=(unit (unit era))
    =invites
    tzid=(unit tape)
  ==
::
+$  rsvp-change
  $:
    =calendar-code
    =event-code
    who=@p
    :: if ~, then uninvite the @p
    status=(unit rsvp)
  ==
::
+$  action
  $%  $:  %create-calendar
          title=@t
      ==
      ::
      $:  %update-calendar
          patch=calendar-patch
      ==
      ::
      $:  %delete-calendar
          =calendar-code
      ==
      ::
      $:  %create-event
          =calendar-code
          organizer=@p
          =detail
          when=moment
          era=(unit era)
          =invites
          tzid=tape
      ==
      ::
      $:  %update-event
          patch=event-patch
      ==
      ::
      :: - delete event
      $:  %delete-event
          =calendar-code
          =event-code
      ==
      :: - cancel event?
      :: - change rsvp
      $:  %change-rsvp
          =rsvp-change
      ==
      :: - import calendar from file
      $:  %import-from-ics
          =path
      ==
  ==
::
::  $initial: sent to subscribers on initial subscription
::
+$  initial
  $%
    [%calendars calendars=(list calendar)]
    [%events-bycal events=(list event)]
  ==
::  $update: updates sent to subscribers
::
+$  update
  $%
    [%calendar-added =calendar]
    [%calendar-changed =calendar]
    [%calendar-removed =calendar-code]
    [%event-added =event]
    [%event-changed =event]
    [%event-removed =event-code]
  ==
--