# learns about system, tries to copy itself
# saves data in xml files inside folder
# orgs send messages to central server

# can take data to
# manipulate or act on
# ip addresses to connect to
# web addresses to screen scrape
# path names to read or write in
# save user paths and network data
# needs to react based on os and wd
# needs to use simple_xml gem

require 'socket'
require 'fileutils'

# modules
require './detect'
require './utils'

class Org
	include Detect, Utils
	attr :memory, :data
	
	def initialize
    @memory = {}
    @data = {}
	end
	
	def live
		puts "\nI'm alive!\n"
		remember; inspect
		inquire; output
	end
	
	def multiply
		target = target_path
		if @data[:os] and @data[:wd]
      case @data[:os]
      when "linux", "macosx"
				FileUtils.cp_r @data[:wd], target
      when "windows"
      end
		end
	end
	
	# chdir and list dirs
	# in each dir until access level reached
	def explore_dirs
		
	end
	
	# needs error checking in
	# case target path unreachable
	def target_path
		target = ""
		slash = @data[:os].eql?("windows") ? "\\" : "/"
		@data[:wd].split(slash).each do |dir|
			if count_char(target, slash) < @data[:depth] - 2
				target << (dir.empty? ? "" : slash) + dir
			end
		end
		return target
	end
	
	def tcp_client host, port
    puts "Connecting to server...\n"
		s = TCPSocket.new host.to_s, port.to_i
		while line = s.gets
			puts line
		end
		s.close
	end
	
	def tcp_server port
    puts "Server running..."
		server = TCPServer.new port.to_i
		loop do
			Thread.start(server.accept) do |client|
				client.puts "\nHello! Time is #{Time.now}!\n"
				client.close
			end
		end
	end
  
  private
	
	def remember
    @data[:in_xml] = ""
	  File.open("out.xml", 'a+').each_line do |l|
      @data[:in_xml] << l
    end
	end
	
	def inspect
    @data[:time] = Time.now.to_s
    @data[:wd] = detect_wd
    @data[:os] = detect_os
    @data[:depth] = detect_depth
  end
	
	def inquire
    puts "\nWhat's up?"
    input = gets; puts "\n"
		input.slice! "\n" # cleans up input
		@data[:input] = input
		scan input
	end
	
	def output
		xml_string = "\n<org>\n"
	  @data.each do |key, val|
	    xml_string << "\t<#{key}>#{val}</#{key}>\n"
	  end
	  xml_string << "</org>\n"
	  File.open("out.xml", 'a+') do |f|
	  	f.write("#{xml_string}")
	  end
    @data[:out_xml] = xml_string
	end
	
	def scan input
		for line in input.split("\n")
			for word in line.split(" ")
				@data[:ip] = detect_ip(word)
				@data[:web] = detect_web(word)
				@data[:path] = detect_path(word)
				@data[:cmd] = detect_cmd(word)
			end
		end
	end
end
