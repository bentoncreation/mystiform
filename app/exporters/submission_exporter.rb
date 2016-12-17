require "csv"

class SubmissionExporter
  attr_reader :submissions

  def initialize(submissions)
    @submissions = submissions.map(&:data)
  end

  def data
    raw_data.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join("")
  end

  private

  def raw_data
    submissions.map { |submission| row(submission) }.unshift(header)
  end

  def header
    columns.map(&:to_s)
  end

  def row(row_hash)
    columns.map { |column| row_hash[column] }
  end

  def columns
    submissions.map(&:keys).flatten.uniq.sort
  end
end
