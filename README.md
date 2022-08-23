# Vault - Anonymization demo

## Tested env

- macOS Monterey 12.5 intel
- python 3.9.12
- HashiCorp Vault Enterprise v1.11.1+ent

## Python Setup

### pip install
```bash
# Install fastapi
pip install fastapi

# Install uvicorn
pip install uvicorn
```

### vault information
```python
# main.py
vault_addr = "http://127.0.0.1:8200"
headers = {
    'X-Vault-Token': 'root'
}
```

## Vault Setup

### License
Trial : <https://www.hashicorp.com/products/vault/trial>

### First terminal

VAULT_LICENSE_PATH=vault.hclic vault-ent server -dev -dev-root-token-id=root

### Second terminal
```bash
export VAULT_TOKEN=root
export VAULT_ADDR=http://127.0.0.1:8200

# Enable transform engine
vault secrets enable transform

# Masking
vault write transform/template/resident-registration-number-tmpl type=regex \
    pattern="\d{6}-\d{1}(\d{6})" \
    alphabet=builtin/numeric
    
vault write transform/transformations/masking/resident-registration-number \
    template=resident-registration-number-tmpl \
    masking_character=# \
    allowed_roles='*'
    
# FPE phone
vault write transform/template/phone-number-tmpl type=regex \
    pattern="\d{2,3}-(\d{3,4})-(\d{4})" \
    alphabet=builtin/numeric
    
vault write transform/transformations/fpe/phone-number \
    template=phone-number-tmpl \
    tweak_source=internal \
    allowed_roles=privacy

# FPE kr-name
vault write transform/alphabet/hangul alphabet="가각간갇갈감갑갓강개객갠갣갤갬갭갯갱갸갹갼갿걀걈걉걋걍걔걕걘걛걜걤걥걧걩거걱건걷걸검겁것겅게겍겐겓겔겜겝겟겡겨격견겯결겸겹겻경계곅곈곋곌곔곕곗곙고곡곤곧골곰곱곳공과곽관괃괄괌괍괏광괘괙괜괟괠괨괩괫괭괴괵괸괻괼굄굅굇굉교굑굔굗굘굠굡굣굥구국군굳굴굼굽굿궁궈궉권궏궐궘궙궛궝궤궥궨궫궬궴궵궷궹귀귁귄귇귈귐귑귓귕규귝균귣귤귬귭귯귱그극근귿글금급긋긍긔긕긘긛긜긤긥긧긩기긱긴긷길김깁깃깅까깍깐깓깔깜깝깟깡깨깩깬깯깰깸깹깻깽꺄꺅꺈꺋꺌꺔꺕꺗꺙꺠꺡꺤꺧꺨꺰꺱꺳꺵꺼꺽껀껃껄껌껍껏껑께껙껜껟껠껨껩껫껭껴껵껸껻껼꼄꼅꼇꼉꼐꼑꼔꼗꼘꼠꼡꼣꼥꼬꼭꼰꼳꼴꼼꼽꼿꽁꽈꽉꽌꽏꽐꽘꽙꽛꽝꽤꽥꽨꽫꽬꽴꽵꽷꽹꾀꾁꾄꾇꾈꾐꾑꾓꾕꾜꾝꾠꾣꾤꾬꾭꾯꾱꾸꾹꾼꾿꿀꿈꿉꿋꿍꿔꿕꿘꿛꿜꿤꿥꿧꿩꿰꿱꿴꿷꿸뀀뀁뀃뀅뀌뀍뀐뀓뀔뀜뀝뀟뀡뀨뀩뀬뀯뀰뀸뀹뀻뀽끄끅끈끋끌끔끕끗끙끠끡끤끧끨끰끱끳끵끼끽낀낃낄낌낍낏낑나낙난낟날남납낫낭내낵낸낻낼냄냅냇냉냐냑냔냗냘냠냡냣냥냬냭냰냳냴냼냽냿넁너넉넌넏널넘넙넛넝네넥넨넫넬넴넵넷넹녀녁년녇녈념녑녓녕녜녝녠녣녤녬녭녯녱노녹논녿놀놈놉놋농놔놕놘놛놜놤놥놧놩놰놱놴놷놸뇀뇁뇃뇅뇌뇍뇐뇓뇔뇜뇝뇟뇡뇨뇩뇬뇯뇰뇸뇹뇻뇽누눅눈눋눌눔눕눗눙눠눡눤눧눨눰눱눳눵눼눽뉀뉃뉄뉌뉍뉏뉑뉘뉙뉜뉟뉠뉨뉩뉫뉭뉴뉵뉸뉻뉼늄늅늇늉느늑는늗늘늠늡늣능늬늭늰늳늴늼늽늿닁니닉닌닏닐님닙닛닝다닥단닫달담답닷당대댁댄댇댈댐댑댓댕댜댝댠댣댤댬댭댯댱댸댹댼댿덀덈덉덋덍더덕던덛덜덤덥덧덩데덱덴덷델뎀뎁뎃뎅뎌뎍뎐뎓뎔뎜뎝뎟뎡뎨뎩뎬뎯뎰뎸뎹뎻뎽도독돈돋돌돔돕돗동돠돡돤돧돨돰돱돳돵돼돽됀됃됄됌됍됏됑되됙된됟될됨됩됫됭됴됵됸됻됼둄둅둇둉두둑둔둗둘둠둡둣둥둬둭둰둳둴둼둽둿뒁뒈뒉뒌뒏뒐뒘뒙뒛뒝뒤뒥뒨뒫뒬뒴뒵뒷뒹듀듁듄듇듈듐듑듓듕드득든듣들듬듭듯등듸듹듼듿딀딈딉딋딍디딕딘딛딜딤딥딧딩따딱딴딷딸땀땁땃땅때땍땐땓땔땜땝땟땡땨땩땬땯땰땸땹땻땽떄떅떈떋떌떔떕떗떙떠떡떤떧떨떰떱떳떵떼떽뗀뗃뗄뗌뗍뗏뗑뗘뗙뗜뗟뗠뗨뗩뗫뗭뗴뗵뗸뗻뗼똄똅똇똉또똑똔똗똘똠똡똣똥똬똭똰똳똴똼똽똿뙁뙈뙉뙌뙏뙐뙘뙙뙛뙝뙤뙥뙨뙫뙬뙴뙵뙷뙹뚀뚁뚄뚇뚈뚐뚑뚓뚕뚜뚝뚠뚣뚤뚬뚭뚯뚱뚸뚹뚼뚿뛀뛈뛉뛋뛍뛔뛕뛘뛛뛜뛤뛥뛧뛩뛰뛱뛴뛷뛸뜀뜁뜃뜅뜌뜍뜐뜓뜔뜜뜝뜟뜡뜨뜩뜬뜯뜰뜸뜹뜻뜽띄띅띈띋띌띔띕띗띙띠띡띤띧띨띰띱띳띵라락란랃랄람랍랏랑래랙랜랟랠램랩랫랭랴략랸랻랼럄럅럇량럐럑럔럗럘럠럡럣럥러럭런럳럴럼럽럿렁레렉렌렏렐렘렙렛렝려력련렫렬렴렵렷령례롁롄롇롈롐롑롓롕로록론롣롤롬롭롯롱롸롹롼롿뢀뢈뢉뢋뢍뢔뢕뢘뢛뢜뢤뢥뢧뢩뢰뢱뢴뢷뢸룀룁룃룅료룍룐룓룔룜룝룟룡루룩룬룯룰룸룹룻룽뤄뤅뤈뤋뤌뤔뤕뤗뤙뤠뤡뤤뤧뤨뤰뤱뤳뤵뤼뤽륀륃륄륌륍륏륑류륙륜륟률륨륩륫륭르륵른륻를름릅릇릉릐릑릔릗릘릠릡릣릥리릭린릳릴림립릿링마막만맏말맘맙맛망매맥맨맫맬맴맵맷맹먀먁먄먇먈먐먑먓먕먜먝먠먣먤먬먭먯먱머먹먼먿멀멈멉멋멍메멕멘멛멜멤멥멧멩며멱면멷멸몀몁몃명몌몍몐몓몔몜몝몟몡모목몬몯몰몸몹못몽뫄뫅뫈뫋뫌뫔뫕뫗뫙뫠뫡뫤뫧뫨뫰뫱뫳뫵뫼뫽묀묃묄묌묍묏묑묘묙묜묟묠묨묩묫묭무묵문묻물뭄뭅뭇뭉뭐뭑뭔뭗뭘뭠뭡뭣뭥뭬뭭뭰뭳뭴뭼뭽뭿뮁뮈뮉뮌뮏뮐뮘뮙뮛뮝뮤뮥뮨뮫뮬뮴뮵뮷뮹므믁믄믇믈믐믑믓믕믜믝믠믣믤믬믭믯믱미믹민믿밀밈밉밋밍바박반받발밤밥밧방배백밴밷밸뱀뱁뱃뱅뱌뱍뱐뱓뱔뱜뱝뱟뱡뱨뱩뱬뱯뱰뱸뱹뱻뱽버벅번벋벌범법벗벙베벡벤벧벨벰벱벳벵벼벽변볃별볌볍볏병볘볙볜볟볠볨볩볫볭보복본볻볼봄봅봇봉봐봑봔봗봘봠봡봣봥봬봭봰봳봴봼봽봿뵁뵈뵉뵌뵏뵐뵘뵙뵛뵝뵤뵥뵨뵫뵬뵴뵵뵷뵹부북분붇불붐붑붓붕붜붝붠붣붤붬붭붯붱붸붹붼붿뷀뷈뷉뷋뷍뷔뷕뷘뷛뷜뷤뷥뷧뷩뷰뷱뷴뷷뷸븀븁븃븅브븍븐븓블븜븝븟븡븨븩븬븯븰븸븹븻븽비빅빈빋빌빔빕빗빙빠빡빤빧빨빰빱빳빵빼빽뺀뺃뺄뺌뺍뺏뺑뺘뺙뺜뺟뺠뺨뺩뺫뺭뺴뺵뺸뺻뺼뻄뻅뻇뻉뻐뻑뻔뻗뻘뻠뻡뻣뻥뻬뻭뻰뻳뻴뻼뻽뻿뼁뼈뼉뼌뼏뼐뼘뼙뼛뼝뼤뼥뼨뼫뼬뼴뼵뼷뼹뽀뽁뽄뽇뽈뽐뽑뽓뽕뽜뽝뽠뽣뽤뽬뽭뽯뽱뽸뽹뽼뽿뾀뾈뾉뾋뾍뾔뾕뾘뾛뾜뾤뾥뾧뾩뾰뾱뾴뾷뾸뿀뿁뿃뿅뿌뿍뿐뿓뿔뿜뿝뿟뿡뿨뿩뿬뿯뿰뿸뿹뿻뿽쀄쀅쀈쀋쀌쀔쀕쀗쀙쀠쀡쀤쀧쀨쀰쀱쀳쀵쀼쀽쁀쁃쁄쁌쁍쁏쁑쁘쁙쁜쁟쁠쁨쁩쁫쁭쁴쁵쁸쁻쁼삄삅삇삉삐삑삔삗삘삠삡삣삥사삭산삳살삼삽삿상새색샌샏샐샘샙샛생샤샥샨샫샬샴샵샷샹섀섁섄섇섈섐섑섓섕서석선섣설섬섭섯성세섹센섿셀셈셉셋셍셔셕션셛셜셤셥셧셩셰셱셴셷셸솀솁솃솅소속손솓솔솜솝솟송솨솩솬솯솰솸솹솻솽쇄쇅쇈쇋쇌쇔쇕쇗쇙쇠쇡쇤쇧쇨쇰쇱쇳쇵쇼쇽숀숃숄숌숍숏숑수숙순숟술숨숩숫숭숴숵숸숻숼쉄쉅쉇쉉쉐쉑쉔쉗쉘쉠쉡쉣쉥쉬쉭쉰쉳쉴쉼쉽쉿슁슈슉슌슏슐슘슙슛슝스슥슨슫슬슴습슷승싀싁싄싇싈싐싑싓싕시식신싣실심십싯싱싸싹싼싿쌀쌈쌉쌋쌍쌔쌕쌘쌛쌜쌤쌥쌧쌩쌰쌱쌴쌷쌸썀썁썃썅썌썍썐썓썔썜썝썟썡써썩썬썯썰썸썹썻썽쎄쎅쎈쎋쎌쎔쎕쎗쎙쎠쎡쎤쎧쎨쎰쎱쎳쎵쎼쎽쏀쏃쏄쏌쏍쏏쏑쏘쏙쏜쏟쏠쏨쏩쏫쏭쏴쏵쏸쏻쏼쐄쐅쐇쐉쐐쐑쐔쐗쐘쐠쐡쐣쐥쐬쐭쐰쐳쐴쐼쐽쐿쑁쑈쑉쑌쑏쑐쑘쑙쑛쑝쑤쑥쑨쑫쑬쑴쑵쑷쑹쒀쒁쒄쒇쒈쒐쒑쒓쒕쒜쒝쒠쒣쒤쒬쒭쒯쒱쒸쒹쒼쒿쓀쓈쓉쓋쓍쓔쓕쓘쓛쓜쓤쓥쓧쓩쓰쓱쓴쓷쓸씀씁씃씅씌씍씐씓씔씜씝씟씡씨씩씬씯씰씸씹씻씽아악안앋알암압앗앙애액앤앧앨앰앱앳앵야약얀얃얄얌얍얏양얘얙얜얟얠얨얩얫얭어억언얻얼엄업엇엉에엑엔엗엘엠엡엣엥여역연엳열염엽엿영예옉옌옏옐옘옙옛옝오옥온옫올옴옵옷옹와왁완왇왈왐왑왓왕왜왝왠왣왤왬왭왯왱외왹왼왿욀욈욉욋욍요욕욘욛욜욤욥욧용우욱운욷울움웁웃웅워웍원웓월웜웝웟웡웨웩웬웯웰웸웹웻웽위윅윈윋윌윔윕윗윙유육윤윧율윰윱윳융으윽은읃을음읍읏응의읙읜읟읠읨읩읫읭이익인읻일임입잇잉자작잔잗잘잠잡잣장재잭잰잳잴잼잽잿쟁쟈쟉쟌쟏쟐쟘쟙쟛쟝쟤쟥쟨쟫쟬쟴쟵쟷쟹저적전젇절점접젓정제젝젠젣젤젬젭젯젱져젹젼젿졀졈졉졋졍졔졕졘졛졜졤졥졧졩조족존졷졸좀좁좃종좌좍좐좓좔좜좝좟좡좨좩좬좯좰좸좹좻좽죄죅죈죋죌죔죕죗죙죠죡죤죧죨죰죱죳죵주죽준줃줄줌줍줏중줘줙줜줟줠줨줩줫줭줴줵줸줻줼쥄쥅쥇쥉쥐쥑쥔쥗쥘쥠쥡쥣쥥쥬쥭쥰쥳쥴쥼쥽쥿즁즈즉즌즏즐즘즙즛증즤즥즨즫즬즴즵즷즹지직진짇질짐집짓징짜짝짠짣짤짬짭짯짱째짹짼짿쨀쨈쨉쨋쨍쨔쨕쨘쨛쨜쨤쨥쨧쨩쨰쨱쨴쨷쨸쩀쩁쩃쩅쩌쩍쩐쩓쩔쩜쩝쩟쩡쩨쩩쩬쩯쩰쩸쩹쩻쩽쪄쪅쪈쪋쪌쪔쪕쪗쪙쪠쪡쪤쪧쪨쪰쪱쪳쪵쪼쪽쫀쫃쫄쫌쫍쫏쫑쫘쫙쫜쫟쫠쫨쫩쫫쫭쫴쫵쫸쫻쫼쬄쬅쬇쬉쬐쬑쬔쬗쬘쬠쬡쬣쬥쬬쬭쬰쬳쬴쬼쬽쬿쭁쭈쭉쭌쭏쭐쭘쭙쭛쭝쭤쭥쭨쭫쭬쭴쭵쭷쭹쮀쮁쮄쮇쮈쮐쮑쮓쮕쮜쮝쮠쮣쮤쮬쮭쮯쮱쮸쮹쮼쮿쯀쯈쯉쯋쯍쯔쯕쯘쯛쯜쯤쯥쯧쯩쯰쯱쯴쯷쯸찀찁찃찅찌찍찐찓찔찜찝찟찡차착찬찯찰참찹찻창채책챈챋챌챔챕챗챙챠챡챤챧챨챰챱챳챵챼챽첀첃첄첌첍첏첑처척천첟철첨첩첫청체첵첸첻첼쳄쳅쳇쳉쳐쳑쳔쳗쳘쳠쳡쳣쳥쳬쳭쳰쳳쳴쳼쳽쳿촁초촉촌촏촐촘촙촛총촤촥촨촫촬촴촵촷촹쵀쵁쵄쵇쵈쵐쵑쵓쵕최쵝쵠쵣쵤쵬쵭쵯쵱쵸쵹쵼쵿춀춈춉춋춍추축춘춛출춤춥춧충춰춱춴춷춸췀췁췃췅췌췍췐췓췔췜췝췟췡취췩췬췯췰췸췹췻췽츄츅츈츋츌츔츕츗츙츠측츤츧츨츰츱츳층츼츽칀칃칄칌칍칏칑치칙친칟칠침칩칫칭카칵칸칻칼캄캅캇캉캐캑캔캗캘캠캡캣캥캬캭캰캳캴캼캽캿컁컈컉컌컏컐컘컙컛컝커컥컨컫컬컴컵컷컹케켁켄켇켈켐켑켓켕켜켝켠켣켤켬켭켯켱켸켹켼켿콀콈콉콋콍코콕콘콛콜콤콥콧콩콰콱콴콷콸쾀쾁쾃쾅쾌쾍쾐쾓쾔쾜쾝쾟쾡쾨쾩쾬쾯쾰쾸쾹쾻쾽쿄쿅쿈쿋쿌쿔쿕쿗쿙쿠쿡쿤쿧쿨쿰쿱쿳쿵쿼쿽퀀퀃퀄퀌퀍퀏퀑퀘퀙퀜퀟퀠퀨퀩퀫퀭퀴퀵퀸퀻퀼큄큅큇큉큐큑큔큗큘큠큡큣큥크큭큰큳클큼큽큿킁킈킉킌킏킐킘킙킛킝키킥킨킫킬킴킵킷킹타탁탄탇탈탐탑탓탕태택탠탣탤탬탭탯탱탸탹탼탿턀턈턉턋턍턔턕턘턛턜턤턥턧턩터턱턴턷털텀텁텃텅테텍텐텓텔템텝텟텡텨텩텬텯텰텸텹텻텽톄톅톈톋톌톔톕톗톙토톡톤톧톨톰톱톳통톼톽퇀퇃퇄퇌퇍퇏퇑퇘퇙퇜퇟퇠퇨퇩퇫퇭퇴퇵퇸퇻퇼툄툅툇툉툐툑툔툗툘툠툡툣툥투툭툰툳툴툼툽툿퉁퉈퉉퉌퉏퉐퉘퉙퉛퉝퉤퉥퉨퉫퉬퉴퉵퉷퉹튀튁튄튇튈튐튑튓튕튜튝튠튣튤튬튭튯튱트특튼튿틀틈틉틋틍틔틕틘틛틜틤틥틧틩티틱틴틷틸팀팁팃팅파팍판팓팔팜팝팟팡패팩팬팯팰팸팹팻팽퍄퍅퍈퍋퍌퍔퍕퍗퍙퍠퍡퍤퍧퍨퍰퍱퍳퍵퍼퍽펀펃펄펌펍펏펑페펙펜펟펠펨펩펫펭펴펵편펻펼폄폅폇평폐폑폔폗폘폠폡폣폥포폭폰폳폴폼폽폿퐁퐈퐉퐌퐏퐐퐘퐙퐛퐝퐤퐥퐨퐫퐬퐴퐵퐷퐹푀푁푄푇푈푐푑푓푕표푝푠푣푤푬푭푯푱푸푹푼푿풀품풉풋풍풔풕풘풛풜풤풥풧풩풰풱풴풷풸퓀퓁퓃퓅퓌퓍퓐퓓퓔퓜퓝퓟퓡퓨퓩퓬퓯퓰퓸퓹퓻퓽프픅픈픋플픔픕픗픙픠픡픤픧픨픰픱픳픵피픽핀핃필핌핍핏핑하학한핟할함합핫항해핵핸핻핼햄햅햇행햐햑햔햗햘햠햡햣향햬햭햰햳햴햼햽햿헁허헉헌헏헐험헙헛헝헤헥헨헫헬헴헵헷헹혀혁현혇혈혐협혓형혜혝혠혣혤혬혭혯혱호혹혼혿홀홈홉홋홍화확환홛활홤홥홧황홰홱홴홷홸횀횁횃횅회획횐횓횔횜횝횟횡효횩횬횯횰횸횹횻횽후훅훈훋훌훔훕훗훙훠훡훤훧훨훰훱훳훵훼훽휀휃휄휌휍휏휑휘휙휜휟휠휨휩휫휭휴휵휸휻휼흄흅흇흉흐흑흔흗흘흠흡흣흥희흭흰흳흴흼흽흿힁히힉힌힏힐힘힙힛힝"

vault write transform/template/kr-name-tmpl \
     type=regex \
     pattern='([가-힣]{2,4})' \
     alphabet=hangul
    
vault write transform/transformations/fpe/kr-name \
template="kr-name-tmpl" \
tweak_source=internal \
allowed_roles="*"

vault write transform/role/customer transformations=kr-name

vault write transform/encode/customer value="한볼트" \
    transformation=kr-name

# Test masking & fpe
vault write transform/role/privacy \
    transformations=resident-registration-number,phone-number
    
vault write transform/encode/privacy value="811111-1234567" \
    transformation=resident-registration-number
    
vault write transform/encode/privacy value="010-1234-5678" \
    transformation=phone-number
    
ENCODED=$(vault write -field=encoded_value transform/encode/privacy value="010-1234-5678" transformation=phone-number)

echo $ENCODED
vault write transform/decode/privacy value=$ENCODED transformation=phone-number

# Enable Transit
vault secrets enable transit

vault write -f transit/keys/aes256 type=aes256-gcm96

vault write transit/encrypt/aes256 plaintext=$(base64 <<< "my secret data")

vault write -field=plaintext transit/decrypt/aes256 ciphertext=vault:v1:BLkHWTk2H5Fks6/CFmAAN3RkvffTJPAycOnH4y7qYuo1Rfay1HDG/axkEg== | base64 -d -

# Tokenization
vault write transform/role/mobile-pay transformations=credit-card

vault write transform/transformations/tokenization/credit-card \
  allowed_roles=mobile-pay \
  max_ttl=24h
  
TOKEN=$(vault write -field=encoded_value transform/encode/mobile-pay value=1111-2222-3333-4444 \
     transformation=credit-card \
     ttl=8h \
     metadata="Organization=HashiCorp" \
     metadata="Purpose=Travel" \
     metadata="Type=AMEX")
     
vault write transform/metadata/mobile-pay value=$TOKEN transformation=credit-card
```

## Run Python Demo App

```bash
uvicorn main:app --reload
```

### Test index page
<http://127.0.0.1:8000/>

### Swagger UI
<http://127.0.0.1:8000/docs>

### API Doc
<http://127.0.0.1:8000/redoc>

### Demo screenshot
![](./demo.png)