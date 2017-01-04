---
layout: post
title: Sending email with raw SMTP (sending emails without an account)
comments: true
---

I often need to send notification emails to myself from applications. It's not really reliable to authenticate your existing email account
and send emails, as authentication can randomly be audited by robot checks and
fail. Recently, I found how to send email with raw SMTP protocol
without needing an account.

### Assumptions & Requirements

1. There's no firewall blocking you from contacting the recipient's mail
   exchange (MX) server port 25
    - For instance, at home I can't seem to contacting gmail MX server port 25.

2. For Gmail at least, you can force your program to use IPv4 when
   communicating with the MX server, or you have a consistent PTR record if
   IPv6 must be used

3. The emails would usually be delivered right into the spam folder. So you
   must be OK with it. You might create a rule to override it.


The workflow is that (inspired by [this SO answer][2]):

1. Look up the MX server for the recipient email address by using `nslookup
   mx`. I find [this][1] online mx lookup service is invaluable.
2. Talk with the MX server in SMTP to send the mail.


Here's an example SMTP session I had with gmail server. Lines marked with `S>`
is server response, those marked with `C>` is from the client:

    S> 220 mx.google.com ESMTP hj1si1000592pac.235 - gsmtp
    C> HELO kfl.com
    S> 250 mx.google.com at your service
    C> MAIL FROM:<k@kfl.com>
    S> 250 2.1.0 OK hj1si1000592pac.235 - gsmtp
    C> RCPT TO:<kfl@gmail.com>
    S> 250 2.1.5 OK hj1si1000592pac.235 - gsmtp
    C> DATA
    S> 354  Go ahead hj1si1000592pac.235 - gsmtp
    C> From: "KL" <kfl@gmail.com>
    C> To: "You" <kfl@gmail.com>
    C> Subject: This is from me
    C>
    C> Hello there:)
    C>
    C> .
    S> 250 2.0.0 OK 1462862782 hj1si1000592pac.235 - gsmtp


Note that if you're accessing internet through a regular consumer ISP, e.g.,
I'm using the crappy Comcast, firstly, you most likely is blocked from
accessing port 25 of the MX server, I haven't tried SSL, maybe it will work.
But from my work environment, I can access port 25 just fine. 

Secondly, if you have IPv6 address and don't have a consistent PTR record (some
sort of DNS reverse lookup strategy), you'll be blocked by Gmail at the end of
the session, like this one. The workaround is to force the client to use IPv4.
Linux telnet client has `-4` command line option. Windows telnet client doesn't
have that, but putty does have this option.


    telnet.exe gmail-smtp-in.l.google.com 25

    220 mx.google.com ESMTP m90si995173pfj.201 - gsmtp
    HELO kfl.com
    250 mx.google.com at your service
    MAIL FROM:<k@kfl.com>
    250 2.1.0 OK m90si995173pfj.201 - gsmtp
    RCPT TO:<kfl@gmail.com>
    250 2.1.5 OK m90si995173pfj.201 - gsmtp
    DATA
    354  Go ahead m90si995173pfj.201 - gsmtp
    From: "KL" <kfl@gmail.com>
    To: "You" <kfl@gmail.com>
    Subject: This is from me

    Hello there:)

    .
    550-5.7.1 [2001:4898:80e8::436] Our system has detected that this message does
    550-5.7.1 not meet IPv6 sending guidelines regarding PTR records and
    550-5.7.1 authentication. Please review
    550-5.7.1  https://support.google.com/mail/?p=ipv6_authentication_error for more
    550 5.7.1 information. m90si995173pfj.201 - gsmtp


Finally, don't forget to check the spam folder for the mail!

[1]: http://mxtoolbox.com/
[2]: http://stackoverflow.com/a/12747310/695964
