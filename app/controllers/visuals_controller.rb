class VisualsController < ApplicationController
  def cases
  end

  def faded
    results = GoogleCustomSearchApi.search(
      params['q'],
      'searchType' => 'image',
      'imgSize' => 'huge',
      'imgColorType' => 'gray'
    )
    @images = results.items.map do |i|
      i['link']
    end.uniq.first(5).join(',')
    Rails.logger.info "69BOT - @images: #{@images}"
  end

  def sfo
  end

  def plinko
  end
end
