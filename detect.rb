# included libraries
require 'rbconfig'
require 'nokogiri'
require 'ipaddr'
require 'uri'

module Detect
	def detect_depth
		case @data[:os]
		when "windows"
			return count_char @data[:wd], "\\"
		else
			return count_char @data[:wd], "/"
		end
	end
	
  # will attempt to write to directories until error
	def detect_access
		access_lvl = 0
		begin
      for dir in @data[:wd].split(slash)
        
      end
		rescue
	    
		end
	end
	
  def detect_cmd cmd
  	case cmd.to_sym
  	when :speak
  		puts "\nHello!\n"
  		return cmd
  	when :output
  		puts @data + "\n"
  		return cmd
  	when :multiply
  		multiply
  		return cmd
    when :server
      tcp_server 2000
      return cmd
    when :client
      tcp_client 'localhost', 2000
      return cmd
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
