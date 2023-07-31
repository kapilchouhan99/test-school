class ResultsController < ApplicationController
  protect_from_forgery except: :create

  #POST /result_data
  def create
    result = Result.new(result_params)
    if result.save
      render json: { message: "Result saved successfully" }, status: :ok
    else
      render json: { message: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def result_params
    params.require(:result).permit(:subject, :marks)
  end
end