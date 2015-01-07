iBeacons
========

Presentation about iBeacons shown on May 26th, 2014 in Zürich CH, August
13th in Leeds UK, August 14th in London UK, September 30th in Amsterdam
NL, and October 28th in Durban, South Africa.

Introduction
------------

This presentation is about iBeacon - a new technology based on Bluetooth
– for both iOS and Android smartphones and tablets. iBeacon offers
unprecedented opportunities to communicate with the user via your mobile
app. There are no complicated configuration or setup, no need to scan QR
codes, etc.

iBeacons is the new frontier. Or at least that is what the press says
every day. Using iBeacons, shops will be able to analyse in detail
consumer behaviour, transport companies will be able to offer better
information to their customers, conferences rooms will become
intelligent and aware of their attendees, and the list goes on and on.

iBeacons show lots of promise and potential, but they raise lots of new
questions; what are the costs? What are the implications in terms of UX?
How about privacy? This 1-hour talk provides an overview of iBeacons
from a conceptual point of view.

This presentation is targeted to both technical (developers, system
architects) and non-technical team members (marketing managers, CEOs,
project managers) interested in the characteristics of this new
technology. It includes live demos of how to use iBeacons and a showcase
of different options available in the market today.

Setup
-----

This application uses 3 or 4 iBeacons, all using the same UDID:
`49EF247E-00B4-4693-A61C-A63C7BD34085`. These beacons would sometimes
include (Estimote)[http://estimote.com] beacons, but also custom-built
Bluetooth 4.0 software running in dedicated devices.

Mac OS X
~~~~~~~~

This presentation used to include an iBeacon running on my MacBook Pro
computer, created using [Matthew Robinson's OS X iBeacon
Code](https://github.com/mttrb/BeaconOSX) which unfortunately no longer
works under Yosemite.

iOS
~~~

During the presentation, I used [Localz's Beacon Toolkit
app](http://localz.co/blog/beacon-toolkit/) to simulate a working
iBeacon on my iPad Air.

Raspberry Pi
~~~~~~~~~~~~

During the presentation I set up a Raspberry Pi unit to broadcast that
same UDID. The application uses the "major" and "minor" numbers to
detect the proximity of any of these beacons, and displays the
corresponding information page in the screen of the iPhone.

The code of the Raspberry Pi can be found in the `Raspberry Pi` folder
in this repository. The `start.sh` and `stop.sh` scripts must be run as
`sudo` and require the [bluez](http://www.bluez.org) library, which must
be installed separately (`sudo apt-get install bluez`.)

