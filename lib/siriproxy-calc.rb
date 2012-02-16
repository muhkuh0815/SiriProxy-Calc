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
    	while doc.match(/(zweier)/)
 			doc = doc.sub( "zweier","2")
 		end
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
	#doc = doc.to_f
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
	
	def ausgabe()
	re = 0
	resp = ask @vor.to_s + " + " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
		while re == 0
			if resp.match(/(Blues)/)
				ph = resp.match(/(Blues)/)
				phh = ph.post_match.strip
				cal = "+"
				res = @res
				replus(@res, phh, cal)
				resp = ask res + " " + cal + " " + @nach + " = " + @res, spoken:  cal + " " + @nach + " = " + @res
			elsif resp.match(/(\+)/)
				ph = resp.match(/(\+)/)
				phh = ph.post_match.strip
				cal = "+"
				res = @res
				replus(@res, phh, cal)
				resp = ask res + " " + cal + " " + @nach + " = " + @res, spoken:  cal + " " + @nach + " = " + @res
			elsif resp.match(/(-)/)
				ph = resp.match(/(-)/)
				phh = ph.post_match.strip
				cal = "-"
				res = @res
				replus(@res, phh, cal)
				resp = ask res.to_s + " " + cal + " " + @nach + " = " + @res, spoken: " minus " + @nach + " = " + @res
			elsif resp.match(/(×)/)  # × not x
				ph = resp.match(/(×)/)
				phh = ph.post_match.strip
				cal = "*"
				replus(@res, phh, cal)
				resp = ask res.to_s + " " + cal + " " + @nach + " = " + @res, spoken: " mal " + @nach + " = " + @res
			elsif resp.match(/(mal)/i)  # × not x
				ph = resp.match(/(mal)/i)
				phh = ph.post_match.strip
				print phh 
				cal = "*"
				replus(@res, phh, cal)
				resp = ask res.to_s + " " + cal.to_s + " " + @nach.to_s + " = " + @res.to_s, spoken: " mal " + @nach.to_s + " = " + @res.to_s
			elsif resp.match(/(\/)/)  # × not x
				ph = resp.match(/(\/)/)
				phh = ph.post_match.strip
				cal = "/"
				replus(@res, phh, cal)
				resp = ask res + " " + cal + " " + @nach + " = " + @res, spoken: "durch " + @nach + " = " + @res
			elsif resp.match(/(dividiert durch)/i)  # × not x
				ph = resp.match(/(dividiert durch)/i)
				phh = ph.post_match.strip
				cal = "/"
				replus(@res, phh, cal)
				resp = ask res + " " + cal + " " + @nach + " = " + @res, spoken: "durch " + @nach + " = " + @res
			elsif resp.match(/(durch)/i)  # × not x
				ph = resp.match(/(durch)/i)
				phh = ph.post_match.strip
				cal = "/"
				replus(@res, phh, cal)
				resp = ask res + " " + cal + " " + @nach + " = " + @res, spoken: "durch " + @nach + " = " + @res
			elsif resp.match(/(ist|gleich)/i)
				say "Ergebniss = " + @res
				re = 1
			elsif resp.match(/(=)/)
				say "Ergebniss = " + @res
				re = 1
			else
				say "Ergebniss = " + @res
				re = 1
				#request_completed
			end
		end 
	end
    
listen_for /(Rechne|berechne) (.*)/i do |phrose,phrase|
	@vor = 0
	@nach = 0
	@res = 0
	ss = ""
	ph = phrase.insert(0, " ")
	ph = ph.to_s
	if phrase.match(/( bloß )/)
		phrase= phrase.sub( " bloß ", " + " )
	end
	if phrase.match(/( \+)/) 
		ma = phrase.match(/( \+)/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "+"
		print cal.to_s
		replus(vor,nach,cal)
		ausgabe()
	elsif phrase.match(/(×)/)  # × not x
		ma = phrase.match(/(×)/)
		vor = ma.pre_match.strip
		print "--v-"
		print vor
		print "--n"
		nach = ma.post_match.strip
		print nach
		cal = "*"
		print "rechnungstart"
		replus(vor,nach,cal)
		print "rechnungsende"
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(mal)/)
		ma = phrase.match(/(mal)/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(Mai)/)
		ma = phrase.match(/(Mai)/)
		vor = ma.pre_match.strip
		nach = ma.post_match.strip
		cal = "*"
		replus(vor,nach,cal)
		say @vor.to_s + " x " + @nach.to_s + " = " + @res.to_s, spoken: " " + @res.to_s
	elsif phrase.match(/(-)/)
		ma = phrase.match(/(-)/)
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
