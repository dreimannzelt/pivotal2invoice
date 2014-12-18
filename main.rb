# Extracts PivotalTracker stories into a text file. The text can be used in invoices to clarify the work billed.

require 'csv'

DATE_FORMAT = '%d.%m.%Y'

input_file = ARGV[0]

table = CSV.read(input_file, headers: true)

current_iteration = nil
table.each do |row|
  if row['Current State'] == 'accepted'

    if row['Iteration'] != current_iteration
      start_at = Date.parse(row['Iteration Start'])
      end_at   = Date.parse(row['Iteration End'])
      puts "\n\nSprint #{row['Iteration']} (#{start_at.strftime(DATE_FORMAT)} - #{end_at.strftime(DATE_FORMAT)})"
      current_iteration = row['Iteration']
    end

    accepted_at = Date.parse(row['Accepted at'])
    unless row['Story Type'] == 'release'
      s = "- #{row['Story']} (PivotalTracker ID #{row['Id']}, abgenommen am #{accepted_at.strftime(DATE_FORMAT)})."
      s+= " Bereich: #{row['Labels']}" unless row['Labels'].nil?
      puts s
    end
  end
end