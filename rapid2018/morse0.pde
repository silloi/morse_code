// ライブラリを読み込み（よくわからなかったらとりあえずそのままにしておいてください）
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Map;

// ゲームシステム用変数（よくわからなかったらとりあえずそのままにしておいてください）
// キーボード入力管理用のKeyboardManager
KeyboardManager keyman;
// フォント（環境によって違ったらヤバそうなので一応スケッチに付属させたVLゴシックを使うことにしている）
PFont font;

// Minimライブラリ用の変数
Minim minim;
// ゲームシステム用変数ここまで


// 以下にグローバル変数を宣言します
HashMap<String,String> hm;
// グローバル変数ここまで

int count;
int duration;
boolean prevPress;
boolean nowPress;

String code;
String target;
String status;
int targetNum;
int sentenceNum;
ArrayList<String> sentence;

// スケッチ実行時に最初に１度だけ実行されます
void setup() {
  // ゲームの初期化
  // ゲームシステムの初期化（よくわからなかったらとりあえずそのままにしておいてください）
  print("文字列描画を初期化中......");
  // KeyboardManagerのインスタンスを作成
  keyman = new KeyboardManager();
  // フォントを読み込む
  font = createFont("fonts/VL-PGothic-Regular.ttf", 24);
  if(font == null) {
    // ここで読み込めていない場合はWindowsと同じで'\'で区切るのかもしれない
    font = createFont("fonts\\VL-PGothic-Regular.ttf", 24);
  }
  textFont(font);
  // 文字描画位置を設定する（座標が左上）
  textAlign(LEFT, TOP);
  println("\t[ OK ]");
  
  print("ビデオを初期化中......");
  // 画面サイズを設定（左から順に幅と高さ）
  size(800, 600);
  // フレームレート（単位はフレーム毎秒）
  // １秒間にここに指定した回数だけdraw()が呼ばれる
  frameRate(30);
  println("\t[ OK ]");
  
  print("サウンドシステムを初期化中......");
  // 音声ライブラリ初期化
  minim = new Minim(this);
  println("\t[ OK ]");
  
  println("完了.");
  // ゲームシステムの初期化ここまで
  
  
  // 以下に追加の初期化処理を書きます

  // 全文


  // Note the HashMap's "key" is a String and "value" is another String
hm = new HashMap<String,String>();

// イロハ - > モールス対応
hm.put("ア", "－－・－－");
hm.put("イ", "・－");
hm.put("ウ", "・・－");
hm.put("エ", "－・－－－");
hm.put("オ", "・－・・・");
hm.put("カ", "・－・・");
hm.put("キ", "－・－・・");
hm.put("ク", "・・・");
hm.put("ケ", "－・－－");
hm.put("コ", "－－－－");
hm.put("サ", "－・－・－");
hm.put("シ", "－－・－・");
hm.put("ス", "－－－・－");
hm.put("セ", "・－－－・");
hm.put("ソ", "－－－・");
hm.put("タ", "－・");
hm.put("チ", "・・－・");
hm.put("ツ", "・－－・");
hm.put("テ", "・－・－－");
hm.put("ト", "・・－・・");
hm.put("ナ", "・－・");
hm.put("ニ", "－・－・");
hm.put("ヌ", "・・・・");
hm.put("ネ", "－－・－");
hm.put("ノ", "・・－－");
hm.put("ハ", "－・・・");
hm.put("ヒ", "－－・・－");
hm.put("フ", "－－・・");
hm.put("ヘ", "・");
hm.put("ホ", "－・・");
hm.put("マ", "－・・－");
hm.put("ミ", "・・－・－");
hm.put("ム", "－");
hm.put("メ", "－・・・－");
hm.put("モ", "－・・－・");
hm.put("ヤ", "・－－");
hm.put("ユ", "－・・－－");
hm.put("ヨ", "－－");
hm.put("ラ", "・・・");
hm.put("リ", "－－・");
hm.put("ル", "－・－－・");
hm.put("レ", "－－－");
hm.put("ロ", "・－・－");
hm.put("ワ", "－・－");
hm.put("ヰ", "・－・・－");
hm.put("ヱ", "・－－・・");
hm.put("ヲ", "・－－－");
hm.put("ン", "・－・－・");
hm.put("゛", "・・");
hm.put("゜", "・・－－・");
hm.put("ー", "・－－・－");
hm.put("　", " ");

// ターゲット全文
sentence = new ArrayList<String>();
sentence.add("イロハニホヘト゛");
sentence.add("チリヌルヲ"); 
sentence.add("ワカ゛ヨタレソ");
sentence.add("ツネナラム");
sentence.add("ウヰノオクヤマ");
sentence.add("ケフコエテ");
sentence.add("アサキユメミシ");
sentence.add("ヱヒモセス゛");
sentence.add("　");
//
 // トンツー初期設定
count = 0;
duration = 15;
prevPress = false;
nowPress = false;

 // コード初期設定
code = "";
status = "";
targetNum = 0;
sentenceNum = 0;
target = sentence.get(sentenceNum);
 //
  // 初期化処理ここまで
}

// ゲームメインループ
void draw(){
  // キー入力情報の更新
  keyman.updateKeys();
  // 画面の消去（背景色をここで指定する）
  background(255, 255, 255);
  
  // 以下にゲームの処理を書きます
prevPress = nowPress; // 前フレームの状態を取得
nowPress = keyman.getKey(" "); // スペースキーの押下を判定

  // count フレームごと加算
count++;

if(!prevPress && nowPress){
  // count の長さでスペース判定
//  if (15 <= count){
//    code += " "; // スペース判定
//  }
    // count を 0 に
  count = 0;
}

if(prevPress && !nowPress){
    // count の長さでトンツー判定
  if(0 <= count && count <= 4){
    code += "・"; // トン判定
  }
  else{
    code += "－"; // ツー判定
  }
  // count を 0 に
count = 0;
}

String targetmorse = hm.get(String.valueOf(target.charAt(targetNum)));

// 画面表示
noFill();
rect(50, 20, 700, 170);
rect(50, 200, 200, 200);
rect(280, 200, 470, 100);
rect(280, 300, 470, 100);
rect(50, 410, 700, 160);
fill(0, 0, 0);
textSize(24);
rText("ツギノ ブンヲ ニュウリョクセヨ：", 400, 40, 0);
textSize(200);
text(target.charAt(targetNum), 50, 170);
textSize(80);
rText(target, 400, 120, 0);
text(targetmorse, 300, 200);
text(code, 300, 300);
fill(255, 0, 0);
rText(status, 400, 480, 0);

// コーディング判定

if(code.length() >= 1){
  if(!code.equals(targetmorse.substring(0,code.length()))){
    code = "";
//    status = "wrong coding!";
  }
}

if(code.equals(targetmorse)){
  targetNum++;
  code = "";
  if(targetNum == target.length()){
    sentenceNum ++;

    // 終端処理
    if(sentenceNum == sentence.size()-1){
      status = "coding done!";

    }
    target = sentence.get(sentenceNum);
    targetNum = 0;
  }
}

  // ゲームの処理ここまで
}

// 何かキーが押されたときに行う処理を書きます
void keyPressed() {
  // 押されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyPressedHook();
}
// 何かキーが離されたときに行う処理を書きます
void keyReleased() {
  // 離されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyReleasedHook();
}
