# frozen_string_literal: true

class NextDay
  class << self
    def call
      Item.all.each do |item|
        item.sell_in = item.sell_in - 1 if item.name != 'Sulfuras, Hand of Ragnaros'

        if (item.name != 'Aged Brie') && (item.name != 'Backstage passes to a TAFKAL80ETC concert')
          decrease_quality(item)
        else
          increase_quality(item)
        end

        if item.sell_in.negative?
          if item.name != 'Aged Brie'
            if item.name != 'Backstage passes to a TAFKAL80ETC concert'
              decrease_quality(item)
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

    private

    def increase_quality(item)
      return unless item.quality < 50

      item.quality = item.quality + 1

      return unless  item.name == 'Backstage passes to a TAFKAL80ETC concert'

      item.quality = item.quality + 1 if item.sell_in < 11
      item.quality = item.quality + 1 if item.sell_in < 6
    end

    def decrease_quality(item)
      return unless item.quality.positive?

      item.quality = item.quality - 1 if item.name != 'Sulfuras, Hand of Ragnaros'
      item.quality = item.quality - 1 if item.name.match?('Conjured')
    end
  end
end
