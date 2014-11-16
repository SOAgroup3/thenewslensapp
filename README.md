
## The-Newslens_App webservice

Authors : LinAnita, peyruchao(peggy) and ethancychen

## Heroku web service

> https://thenewslensapp2.herokuapp.com/

### Introduction: Read the hot news from The News Lens ( http://www.thenewslens.com )

> This service could let users to use GET and POST funtions to get some information of the news.


###Usage

- GET   /
   returns the status to indicate service is alive

- GET   /api/v1/:<number>.json
   returns JSON of <number> of the least news include : title, author, dates

- POST  /api/v1/specify.json
   takes JSON: array of column header
   returns: array of news titles on NewLens 

- GET   /api/v1/tutorial/:number
	return specific number of records that stored in database 

> <pre>

If users use the GET function by thaking /api/v1/:4.json.

It will show the four information of the news.

```[{"title":"歐巴馬難逃「六年之癢」詛咒 民主黨期中選舉恐被拖垮","author":"TNL 編輯","date":"2014-11-02"},{"title":"挽救選情顧鐵票 藍營立委擬恢復軍公教年終慰問金","author":"TNL 編輯","date":"2014-11-02"},{"title":"美軍撤離中國接收 外媒：中國「無需流一滴血」就成為阿富汗的終極贏家","author":"TNL 編輯","date":"2014-11-02"},{"title":"關廠工人案宣告落幕 勞動部完成96%退款作業","author":"TNL 編輯","date":"2014-11-02"}] ```
</pre>

> <pre>

If users use the POST function by thaking /api/v1/specify.json

It will show the four information of the news.

Example:

```[{"title":"歐巴馬難逃「六年之癢」詛咒 民主黨期中選舉恐被拖垮"},{"title":"挽救選情顧鐵票 藍營立委擬恢復軍公教年終慰問金"},{"title":"美軍撤離中國接收 外媒：中國「無需流一滴血」就成為阿富汗的終極贏家"},{"title":"關廠工人案宣告落幕 勞動部完成96%退款作業"},{"title":"立法院初審通過僱主性別歧視 罰鍰上修至150萬"},{"title":"【插畫】「賣完了！吃其他的」，三張圖看港台飲食習慣大不同"},{"title":"攝影師帶你看世界：超精采3分半鐘影片，看完彷彿也環遊了世界"} ```