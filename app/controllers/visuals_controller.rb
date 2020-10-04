class VisualsController < ApplicationController
  def cases
  end

  def faded
    respond_to do |format|
      results = GoogleCustomSearchApi.search(
        params['q'],
        'searchType' => 'image',
        'imgSize' => 'huge',
        'imgColorType' => 'gray'
      )
      @images = results.items.map do |i|
        i['link']
      end.uniq.first(8)
      format.json { render json: @images }
      format.html { render }
    end
  end

  def sfo
  end
end
