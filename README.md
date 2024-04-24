# Godot Folta UI

Godot4 アドオン

## 説明

GodotデフォルトのUI用ノードであるControlでは以下のような問題があります。
- フォーカス移動のスピードを制御できない
- メニュー階層を作るのが面倒

このリポジトリではその問題を回避していい感じにカスタマイズできるようにまとめました。

フレームワークよりはシーンやスクリプトに手を入れて使用する汎用パーツに近いです。

- キーボード、マウス、ジョイパッド対応
- 長押しで速度を徐々に速くする
- 空状態
  - アイテムメニューなど、データはあるが非表示・無効にすることで表示切替ごとにボタンのインスタンスを全て作成するのを防ぎます。
  - 枠だけ用意してデータを後から設定するなど

## 使い方
`addons/godot-folta-ui` をGodotプロジェクトに入れます。

`addons`ディレクトリには入れますが、アドオンを有効にする必要はありません。

### デバッガ

`res://addons/godot-folta-ui/command_list_debugger.tscn` をゲーム内に追加してプレイすると、

現在のゲームシーン内のメニューの状態のデバッガが表示されます。

![image](https://github.com/folt-a/godot-folta-ui/assets/32963227/58c45b1c-2a66-4175-8a8b-df8a0fff31f6)

![image](https://github.com/folt-a/godot-folta-ui/assets/32963227/08eab2d7-0095-48af-91a8-1fe114cb8ef6)

UIメニューなので、複数のメニューが同時に有効になる場合は想定していません。

そのため、複数のメニューが有効になると警告のため黄色くなります。

![image](https://github.com/folt-a/godot-folta-ui/assets/32963227/bdb11201-d97b-44e8-898b-239b63879c8b)
