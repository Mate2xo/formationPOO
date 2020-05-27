# frozen_string_literal: true

class NextDay
  class << self
    def call
      Item.all.each do |item|
        if (item.name != 'Aged Brie') && (item.name != 'Backstage passes to a TAFKAL80ETC concert')
          item.quality = item.quality - 1 if item.quality > 0 && item.name != 'Sulfuras, Hand of Ragnaros'
          item.quality = item.quality - 1 if item.name.match? 'Conjured'
        elsif item.quality < 50
          item.quality = item.quality + 1
          if item.name == 'Backstage passes to a TAFKAL80ETC concert'
            item.quality = item.quality + 1 if item.sell_in < 11
            item.quality = item.quality + 1 if item.sell_in < 6
          end
        end

        item.sell_in = item.sell_in - 1 if item.name != 'Sulfuras, Hand of Ragnaros'

        if item.sell_in.negative?
          if item.name != 'Aged Brie'
            if item.name != 'Backstage passes to a TAFKAL80ETC concert'
              item.quality = item.quality - 1 if item.name != 'Sulfuras, Hand of Ragnaros' && item.quality.positive?
              item.quality = item.quality - 1 if item.name.match? 'Conjured'
            else
              item.quality = item.quality - item.quality
            end
          else
            item.quality = item.quality + 1 if item.quality < 50
          end
        end
        item.save
      end
    end
  end
end
