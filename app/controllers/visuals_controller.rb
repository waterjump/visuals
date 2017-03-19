class VisualsController < ApplicationController
  def cases
  end

  def faded
    results = GoogleCustomSearchApi.search(
      params['q'],
      search_type: 'image',
      img_size: 'large'
    )
    @images = results.items.map do |i|
      next unless i['pagemap'].present?
      next unless i['pagemap']['cse_image'].present?
      i['pagemap']['cse_image'].first['src']
    end.uniq.first(5).join(',')
    Rails.logger.info "69BOT - @images: #{results}"
  end

  def sfo
  end

  def plinko
  end
end
