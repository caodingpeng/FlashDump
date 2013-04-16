FlashDumper
===========

FlashDumper is a tool to help code monkeys do UI work more easier.
It will export flash elements layout and assets with one button click.
Layout information is in json format, so we can import the UI to our real project easily.

Currently we supports the following UI controls
* Sprite
* Button
* MovieClip
* Text
* Image
* Progressbar

Here is a sample layout file.
```json
{
    "root": [
        {
            "x": 30,
            "y": 40,
            "type": "image",
            "name": "control1",
            "image": "skull_selected"
        },
        {
            "x": 80,
            "y": 80,
            "type": "button",
            "name": "control_button",
            "background_normal": "button-down-skin",
            "background_pressed": "button-up-skin",
            "text": "control movie",
            "stringID": "main.hello",
            "font": "tahoma30_0",
            "font_size":20
        },
        {
            "x": 250,
            "y": 250,
            "type": "sprite",
            "name": "control_sprite",
            "children": [
                {
                    "x": 10,
                    "y": 10,
                    "type": "movie",
                    "name": "control_movie",
                    "animation_image": "bigcoin00",
  	    		"frame_count":24
                },
                {
                    "x": 50,
                    "y": 50,
                    "type": "text",
                    "name": "control_text",
                    "text": "MyText",
                    "stringID": "maind.text",
                    "width": 100,
                    "height": 200,
                    "font": "tahoma30_0",
            		"font_size":30
                }
            ]
        }
    ]
}
```

if you neet problems when using this tool, contace me cdingpeng@zynga.com