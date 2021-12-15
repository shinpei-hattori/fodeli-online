hokkaido = [
  旭川市,釧路市,江別市,札幌市,小樽市,
  帯広市,苫小牧市,函館市,北見市
]
hokkaido.each { |n| Area.create!(city: n, prefecture_id: 2) }

aomori = [
  弘前市,青森市,八戸市
]
aomori.each { |n| Area.create!(city: n, prefecture_id: 3) }


iwate = [
  一関市,奥州市,盛岡市
]
iwate.each { |n| Area.create!(city: n, prefecture_id: 4) }

miyagi = [
  石巻市,仙台市,大崎市
]
miyagi.each { |n| Area.create!(city: n, prefecture_id: 5) }

akita = [
  横手市,秋田市
]
akita.each { |n| Area.create!(city: n, prefecture_id: 6) }


yamagata = [
  山形市,酒田市,鶴岡市
]
yamagata.each { |n| Area.create!(city: n, prefecture_id: 7) }

fukushima = [
  いわき市,会津若松市,郡山市,福島市
]
fukushima.each { |n| Area.create!(city: n, prefecture_id: 8) }

ibaraki = [
  つくば市,水戸市,日立市
]
ibaraki.each { |n| Area.create!(city: n, prefecture_id: 9) }

tochigi = [
  宇都宮市,小山市,栃木市
]
tochigi.each { |n| Area.create!(city: n, prefecture_id: 10) }

gunma = [
  伊勢崎市,高崎市,前橋市,太田市
]
gunma.each { |n| Area.create!(city: n, prefecture_id: 11) }

saitama = [
  さいたま市,越谷市,熊谷市,春日部市,所沢市,
  上尾市,川越市,川口市,草加市
]
saitama.each { |n| Area.create!(city: n, prefecture_id: 12) }

chiba = [
  市原市,市川市,松戸市,千葉市,船橋市,
  柏市,八千代市,流山市
]
chiba.each { |n| Area.create!(city: n, prefecture_id: 13) }

tokyo = [
  中央区、千代田区、文京区、港区、新宿区、品川区、目黒区、
  大田区、世田谷区、渋谷区、中野区、杉並区、練馬区、板橋区、
  豊島区、北区, 台東区、墨田区、江東区、荒川区、足立区、葛飾区、
  江戸川区
]
tokyo.each { |n| Area.create!(city: n, prefecture_id: 14) }

kanagawa = [
  横須賀市,横浜市,茅ヶ崎市,厚木市,小田原市,
  崎市,相模原市,大和市,藤沢市,平塚市
]
kanagawa.each { |n| Area.create!(city: n, prefecture_id: 15) }

nigata = [
  上越市,新潟市,長岡市
]
nigata.each { |n| Area.create!(city: n, prefecture_id: 16) }

toyama = [
  高岡市,富山市
]
toyama.each { |n| Area.create!(city: n, prefecture_id: 17) }

ishikawa = [
  金沢市,小松市,白山市
]
ishikawa.each { |n| Area.create!(city: n, prefecture_id: 18) }

fukui = [
  坂井市,福井市
]
fukui.each { |n| Area.create!(city: n, prefecture_id: 19) }

yamanashi = [
  甲斐市,甲府市
]
yamanashi.each { |n| Area.create!(city: n, prefecture_id: 20) }

nagano = [
  松本市,上田市,長野市
]
nagano.each { |n| Area.create!(city: n, prefecture_id: 21) }

gifu = [
  岐阜市,大垣市
]
gifu.each { |n| Area.create!(city: n, prefecture_id: 22) }

shizuoka = [
  沼津市,静岡市,磐田市,浜松市,富士市
]
shizuoka.each { |n| Area.create!(city: n, prefecture_id: 23) }

aichi = [
  安城市,一宮市,岡崎市,春日井市,豊橋市,
  豊川市,豊田市,名古屋市
]
aichi.each { |n| Area.create!(city: n, prefecture_id: 24) }

mie = [
  四日市,市津市,鈴鹿市
]
mie.each { |n| Area.create!(city: n, prefecture_id: 25) }

shiga = [
  草津市,大津市
]
shiga.each { |n| Area.create!(city: n, prefecture_id: 26) }

kyoto = [
  宇治市,京都市
]
kyoto.each { |n| Area.create!(city: n, prefecture_id: 27) }

osaka = [
  茨木市,岸和田市,高槻市,堺市,寝屋川市,吹田市,大阪市,
  東大阪市,八尾市,豊中市,枚方市,和泉市
]
osaka.each { |n| Area.create!(city: n, prefecture_id: 28) }

hyogo = [
  伊丹市,加古川市,神戸市,西宮市,
  尼崎市,姫路市,宝塚市,明石市
]
hyogo.each { |n| Area.create!(city: n, prefecture_id: 29) }

nara = [
  橿原市,奈良市
]
nara.each { |n| Area.create!(city: n, prefecture_id: 30) }

wakayama = [
  田辺市,和歌山市
]
wakayama.each { |n| Area.create!(city: n, prefecture_id: 31) }

tottori = [
  鳥取市,米子市
]
tottori.each { |n| Area.create!(city: n, prefecture_id: 32) }

shimane = [
  出雲市,松江市
]
shimane.each { |n| Area.create!(city: n, prefecture_id: 33) }

okayama = [
  岡山市,倉敷市,津山市
]
okayama.each { |n| Area.create!(city: n, prefecture_id: 34) }

hiroshima = [
  呉市,広島市,東広島市,福山市
]
hiroshima.each { |n| Area.create!(city: n, prefecture_id: 35) }

yamaguchi = [
  宇部市,下関市,岩国市,山口市,周南市,防府市
]
yamaguchi.each { |n| Area.create!(city: n, prefecture_id: 36) }

tokushima = [
  阿南市,徳島市
]
tokushima.each { |n| Area.create!(city: n, prefecture_id: 37) }

kagawa = [
  丸亀市,高松市
]
kagawa.each { |n| Area.create!(city: n, prefecture_id: 38) }

ehime = [
  今治市,松山市
]
ehime.each { |n| Area.create!(city: n, prefecture_id: 39) }

kochi = [
  高知市,南国市
]
kochi.each { |n| Area.create!(city: n, prefecture_id: 40) }

fukuoka = [
  久留米市,飯塚市,福岡市,北九州市
]
fukuoka.each { |n| Area.create!(city: n, prefecture_id: 41) }

saga = [
  佐賀市
  唐津市
]
saga.each { |n| Area.create!(city: n, prefecture_id: 42) }

nagasaki = [
  佐世保市,長崎市,諫早市
]
nagasaki.each { |n| Area.create!(city: n, prefecture_id: 43) }

kumamoto = [
  熊本市,八代市
]
kumamoto.each { |n| Area.create!(city: n, prefecture_id: 44) }

oita = [
  大分市,別府市
]
oita.each { |n| Area.create!(city: n, prefecture_id: 45) }

miyazaki = [
  延岡市,宮崎市,都城市
]
miyazaki.each { |n| Area.create!(city: n, prefecture_id: 46) }

kagoshima = [
  鹿屋市,鹿児島市,霧島市
]
kagoshima.each { |n| Area.create!(city: n, prefecture_id: 47) }

okinawa = [
  那覇市
]
okinawa.each { |n| Area.create!(city: n, prefecture_id: 48) }