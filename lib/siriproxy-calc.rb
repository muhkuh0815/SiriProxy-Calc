# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'
require 'decimal'
#require 'httparty'


#######
# 
# just a simple Calculator Plugin
#
#      Remember to add the plugin to the "/.siriproxy/config.yml" file !
#
# ein einfaches Rechner Plugin
#
#      Plugin in "/.siriproxy/config.yml" file hinzufügen !
#
### Syntax
#
# till now only simply calculations work, like +, -, * and /
#
# rechne 6 x 2
# berechne 7,23 * 2,3
#
#
### Todo
#
# Checking for float
# ask instead of say - so you can calculate  5 + 5 then + 4 and - 7 ...
#
#
### Contact
#
# Twitter: @muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-Calc
######

class SiriProxy::Plugin::Calc < SiriProxy::Plugin
        
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def ror
    end
    def res
    end
    def rer
    end

    def cleanup(doc)
    doc = doc.to_s
 		while doc.match(/(eins)/)
 			doc = doc.sub( "eins","1")
 		end
 		while doc.match(/(zwei)/)
 			doc = doc.sub( "zwei","2")
 		end
 		while doc.match(/(drei)/)
 			doc = doc.sub( "drei","3")
 		end
 		while doc.match(/(vier)/)
 			doc = doc.sub( "vier","4")
 		end
 		while doc.match(/(fünf)/)
 			doc = doc.sub( "fünf","5")
 		end
 		while doc.match(/(sechs)/)
 			doc = doc.sub( "sechs","6")
 		end
 		while doc.match(/(sex)/)
 			doc = doc.sub( "sex","6")
 		end
 		while doc.match(/(sieben)/)
 			doc = doc.sub( "sieben","7")
 		end
 		while doc.match(/(acht)/)
 			doc = doc.sub( "acht","8")
 		end
 		while doc.match(/(neun)/)
 			doc = doc.sub( "neun","9")
 		end
 		while doc.match(/(null)/)
 			doc = doc.sub( "null","0")
 		end
 		while doc.match(/(zehn)/)
 			doc = doc.sub( "zehn","10")
 		end
 		while doc.match(/( )/)
			doc = doc.sub( " ", "" )
		end
	doc = doc.sub( ".", "" )
	doc = doc.sub( ",", "." )
	doc = doc.strip
 	return doc
 	end

	def replus(re,ro,cal)
		rer = cleanup(re)
		ror = cleanup(ro)
		#rer = rerr if ( Float( rerr ) rescue false )
		#ror = rorr if ( Float( rorr ) rescue false )
		res = res.to_f
		print cal
		if cal == "+"
			res = Decimal(rer) + Decimal(ror) 
		elsif cal == "*"
			res = Decimal(rer) * Decimal(ror)
		elsif cal == "-"
			res = Decimal(rer) - Decimal(ror)
		elsif cal == "/"
			res = (rer.to_f)/(ror.to_f)
		end
		@vor = rer
		@nach = ror
		@res = res.to_s.sub( ".", "," )
		return rer,ror
	end
    
listen_for /(Rechne|berechne) (.*)/i do |phrose,phrase|
	@vor = 0
	@nach = 0
	@res = 0
	ss = ""
	ph = phrase.insert(0, " ")
	ph = ph.to_s
	if phrase.match(/( \+ )/) 
		ma = phrase.match(/( \+ )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "+"
		replus(vor,nach,cal)
		say @vor.to_s + " + " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( × )/)  # × not x
		ma = phrase.match(/( × )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(mal )/)
		ma = phrase.match(/(mal )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( - )/)
		ma = phrase.match(/( - )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "-"
		replus(vor,nach,cal)
		say @vor.to_s + " - " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(\/)/)
		ma = phrase.match(/(\/)/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "/"
		replus(vor,nach,cal)
		say @vor.to_s + " / " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/( durch )/)
		ma = phrase.match(/( durch )/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "/"
		replus(vor,nach,cal)
		say @vor.to_s + " / " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	else
		mh = phrase
		print "-----HÄÄ----"
		print mh
		say "WTF", spoken: "Hä, Wos Wüsst ?"
	end
	request_completed
end
end
