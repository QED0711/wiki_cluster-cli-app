module WikiCluster

    class CLI

      def self.run(url = nil)
        # Prompts the user for a URL if not provided with one.
        if !url
          puts "Type or paste a Wikipedia link here: "
          url = gets.chomp
        end

        #  Initializes the starting point as a new Node instance, and scrapes all links from this starting point.
        root = Node.new(url)
        puts "\n#{root.links.length} links on this page. Searching each linked page for the most relevant articles..."
        if root.links.length > 250
          puts "(Because of the number of links, this may take a few minutes...)"
        end

        # For each link scraped from the base url, creates new Node instances and scrapes links from each of those.
        root.links.each do |link|
          Node.new('https://en.wikipedia.org' + link)
        end

        # counts the number of times each link appeared in the cluster of scraped links, and sorts them from most to least prevalent
        # returns the top ten results
        most_frequent = Cluster.most_frequent
        puts "\n ============================= \n\n"

        # Prints the top ten links to the terminal, and indicates how many times that link was found in the cluster
        most_frequent.each.with_index {|link, index| puts "#{index + 1}. Linked #{link[1]} times in associated articles: https://en.wikipedia.org#{link[0]}\n\n"}

        # prompts the user to click a link and be redirected to the article, indicate a link index and start the process over from there, or exit the program.
        puts "Click one of the links above, or enter the associated number to re-run the program using that link as a starting point. (press ENTER/RETURN to exit)"

        input = gets.chomp
        if input != ""
          puts "\n ============================= \n\n"
          puts "https://en.wikipedia.org" + most_frequent[input.to_i - 1][0]
          CLI.run("https://en.wikipedia.org" + most_frequent[input.to_i - 1][0])
        end

      end

    end


 end
