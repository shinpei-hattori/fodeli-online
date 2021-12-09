require 'rails_helper'

RSpec.describe "個人チャットのメッセージ", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:no_authority) { create(:user) }
  let!(:room) {create(:dm_room)}
  let!(:entry1) { create(:dm_entry,user:user,dm_room: room) }
  let!(:entry2) { create(:dm_entry,user:other_user,dm_room: room) }
end
