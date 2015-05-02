# learns about system, tries to copy itself
# saves data in xml files inside folder
# orgs send messages to central server

# can take data to manipulate or act on
# ip addresses to connect to
# web addresses to screen scrape
# path names to read or write in
# save user paths and network data

class Org
	def initialize input
		input.slice! "\n" # cleans up input
		@data = "<input>#{input}</input>\n"
		@data << "<os>#{detect_os}</os>\n"
		scan input
	end
	
	def live
	  File.open("out.xml", 'w') do |f|
	  	f.write("#{@data}")
	  end
		puts @data + "\n"
	end
	
	def scan input
		for line in input.split("\n")
			for word in line.split(" ")
				@data << detect_ip(word)
				@data << detect_web(word)
			end
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
