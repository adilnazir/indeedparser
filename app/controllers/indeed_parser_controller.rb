class IndeedParserController < ApplicationController
  def show
  end

  def parse
    Delayed::Job.enqueue(ParsingJob.new(params[:query_string]))
    redirect_to indeed_parser_show_path, :notice => "Job has been sent for processing. You can see the output on google sheet."
  end
end
