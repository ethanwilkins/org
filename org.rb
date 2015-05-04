# learns about system, tries to copy itself
# saves data in xml files inside folder
# orgs send messages to central server

# can take data to manipulate or act on
# ip addresses to connect to
# web addresses to screen scrape
# path names to read or write in
# save user paths and network data

# library modules
require 'fileutils'
require 'rbconfig'
require 'nokogiri'
require 'ipaddr'
require 'uri'

class Org
	def initialize
    @data = {}
	end
	
	# needs to react based on os and wd
	def live
		puts "\nI'm alive!\n"
		inspect; inquire; output
	end
	
	def remember
	  @memory = File.open("out.xml", 'a+')
	end
	
	def inspect
    @data[:os] = "<os>#{detect_os}</os>"
    @data[:wd] = "<wd>#{detect_wd}</wd>"
	end
	
	def inquire
    puts "\nWhat's up?"
    input = gets; puts "\n"
		input.slice! "\n" # cleans up input
		@data[:input] = "<input>#{input}</input>"
		scan input
	end
	
	def output
		xml_string = "\n<org>\n"
	  @data.each do |key, val|
	    xml_string << "\t#{val}\n"
	  end
	  xml_string << "</org>\n"
	  File.open("out.xml", 'a+') do |f|
	  	f.write("#{xml_string}")
	  end
	  puts xml_string
	end
	
	def multiply
	
	end
	
	def scan input
		for line in input.split("\n")
			for word in line.split(" ")
				@data[:ip] = "<ip>#{detect_ip(word)}</ip>"
				@data[:web] = "<web>#{detect_web(word)}</web>"
				@data[:path] = "<path>#{detect_path(word)}</path>"
				@data[:cmd] = "<cmd>#{detect_cmd(word)}</cmd>"
			end
		end
	end
  
  def detect_cmd cmd
  	case cmd.to_sym
  	when :speak
  		puts "\nHello!\n"
  		return cmd
  	when :output
  		puts @data
  		return cmd
  	else
  		return ""
  	end
  end
	
	def detect_path path
		if (path.include? "/" or path.include? "\\") \
			and not (path.include? "\\\\" or path.include? "//")
			return path
		else
			return ""
		end
	end
	
	def detect_web addr
		if /\A#{URI::regexp}\z/ =~ addr
			return addr
		else
			return ""
		end
	end
	
	def detect_ip ip
		if /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ =~ ip
			return ip
		else
			return ""
		end
	end
	
	def detect_wd
		unless Dir.pwd.nil?
			return Dir.pwd.to_s
		else
			return ""
		end
	end

  def detect_os
    os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
      end
    )
    return os.to_s if os
  end
end
