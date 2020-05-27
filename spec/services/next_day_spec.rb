# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextDay, type: :service do
  subject { described_class.call }

  it 'reduces the quality of an item by 1' do
    item = create :item, quality: 20

    subject

    expect(item.reload.quality).to eq 19
  end

  it "reduces an item's sell_in by 1" do
    item = create :item, sell_in: 20

    subject

    expect(item.reload.sell_in).to eq 19
  end

  context "when an item's sell_in has expired," do
    it 'reduces quality by 2' do
      item = create :item, sell_in: -1, quality: 20

      subject

      expect(item.reload.quality).to eq 18
    end
  end

  context "when an item's quality is 0," do
    it 'cannot become negative' do
      item = create :item, quality: 0

      subject

      expect(item.reload.quality).to eq 0
    end
  end

  context "with a 'Aged Brie' item:" do
    it 'increases quality' do
      item = create :item, name: 'Aged Brie', quality: 20

      subject

      expect(item.reload.quality).to eq 21
    end
  end

  context "when an item's quality is >= 50" do
    it 'does not increases it further' do
      item = create :item, name: 'Aged Brie', quality: 50

      subject

      expect(item.reload.quality).to eq 50
    end
  end

  context "with a 'Sulfuras' item" do
    it 'does not lose quality' do
      item = create :item, name: 'Sulfuras, Hand of Ragnaros', quality: 80

      subject

      expect(item.reload.quality).to eq 80
    end
  end

  context "with a 'Backstage pass' item:" do
    it 'increases quality' do
      item = create :item,
                    name: 'Backstage passes to a TAFKAL80ETC concert',
                    quality: 20

      subject

      expect(item.reload.quality).to eq 21
    end

    context "when there's <= 10 days left" do
      it 'increases quality by 2' do
        item = create :item,
                      name: 'Backstage passes to a TAFKAL80ETC concert',
                      sell_in: 10,
                      quality: 20

        subject

        expect(item.reload.quality).to eq 22
      end
    end

    context "when there's <= 5 days left" do
      it 'increases quality by 3' do
        item = create :item,
                      name: 'Backstage passes to a TAFKAL80ETC concert',
                      sell_in: 5,
                      quality: 20

        subject

        expect(item.reload.quality).to eq 23
      end
    end
  end
end
