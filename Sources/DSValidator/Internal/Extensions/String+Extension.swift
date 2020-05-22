//
//  String+Extension.swift
//  DSValidator
//
//  Created by Dzmitry Simkin on 5/1/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import Foundation

extension String {

    public var isEmail: Bool {
        get { validateRegexp(String.emailRegEx) }
    }

    public var isName: Bool {
        get { validateRegexp(String.nameRegexp) }
    }

    public var isHttp: Bool {
        return validateRegexp(String.httpRegexp)
    }

    public var isFile: Bool {
        return validateRegexp(String.fileRegexp)
    }

    public var isWebSocket: Bool {
        return validateRegexp(String.webSocketRegexp)
    }

    public var isIPv4: Bool {
        return validateRegexp(String.IPv4Regexp)
    }

    public var isIPv6: Bool {
        return validateRegexp(String.IPv6Regexp)
    }

    public var isDomain: Bool {
        return validateRegexp(String.domainNameRegexp)
    }

    public var isGeoCoordinate: Bool {
        return validateRegexp(String.geoCordinateRegexp)
    }

    public var isDecimal: Bool {
        return validateRegexp(String.decimalRegexp)
    }

    public var hasEmoji: Bool {
        return validateCharactersSet(String.emojisCharactersSet)
    }

    public var hasNoEmoji: Bool {
        return !validateCharactersSet(String.emojisCharactersSet)
    }

    // MARK: - Internal

//    private func testRegexp(_ pattern: String, options: NSRegularExpression.Options = [.caseInsensitive]) -> Bool {
//        do {
//            let regex = try NSRegularExpression(pattern: pattern, options: options)
//            let range = NSRange(location: 0, length: self.utf16.count)
//            let mathces = regex.matches(in: self, range: range)
//            return mathces.first != nil
//        } catch {
//            print("DS: Error: \(error)")
//            return false
//        }
//    }

    private func validateCharactersSet(_ set: CharacterSet) -> Bool {
        let range = rangeOfCharacter(from: set, options: [.caseInsensitive], range: nil)
        let valid = range != nil
        return valid
    }

    private func validateRegexp(_ regexp: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexp)
        let result = predicate.evaluate(with: self.lowercased())
        return result
    }

    // MARK: - Regexps

    // FULL RFC 5322 regexp (https://www.regular-expressions.info/email.html)
    //    private static let emailRegEx = "\\A(?:[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\\z"

    // Omiting IP addresses, domain-specific addresses, the syntax using double quotes and square brackets.
    // It will still match 99.99% of all email addresses in actual use today (https://www.regular-expressions.info/email.html)
    private static let emailRegEx = "\\A[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z"

    // simplified email regexp
    //    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    private static let nameRegexp = "[a-zA-Z ,.'-]+"

    private static let httpRegexp = "^(https?://)?((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|((\\d{1,3}\\.){3}\\d{1,3}))(\\:\\d{2,5})?(/[-a-z\\d%_.~+]*)*(\\?[;&a-z\\d%_.~+=-]*)?(\\#[-a-z\\d_]*)?$"

    private static let webSocketRegexp = "^wss?://((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|((\\d{1,3}\\.){3}\\d{1,3}))(\\:\\d{2,5})?(/[-a-z\\d%_.~+]+)*(\\?[;&a-z\\d%_.~+=-]*)?(\\#[-a-z\\d_]*)?$"

    private static let fileRegexp =
//    "^file://((([a-zA-Z\\d-]*[a-zA-Z\\d])*)\\.?)+([a-zA-Z]{2,})?(/[-a-zA-Z\\d%_.~+]+)*$"
    "^file://((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|((\\d{1,3}\\.){3}\\d{1,3}))(\\:\\d{2,5})?(/[-a-z\\d%_.~+]+)*$"

    private static let IPv4Regexp = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

    private static let IPv6Regexp = "((^|:)([0-9a-fA-F]{0,4})){1,8}$"

    private static let domainNameRegexp = "([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]"

    private static let geoCordinateRegexp = "^[-+]?([1-8]?\\d(\\.\\d+)?|90(\\.0+)?),\\s*[-+]?(180(\\.0+)?|((1[0-7]\\d)|([1-9]?\\d))(\\.\\d+)?)$"

    private static let decimalRegexp = "^-?\\d*[.,]?\\d+$"

    private static let emojisCharactersSet = CharacterSet(charactersIn: "😃😄😁😆😅😂😉😊😍😘☺️😚😋😜😝😏😒😌😔😪😷😵😲😳😨😰😥😢😭😱😖😣😞😓😩😫😤😡😠👿💀💩👹👺👻👽👾😺😸😹😻😼😽🙀😿😾🙈🙉🙊💋💌💘💝💖💗💓💞💕💟💔❤️💛💚💙💜💯💢💥💫💦💨💣💬💤👋✋👌✌️👈👉👆👇☝️👍👎✊👊👏🙌👐🙏💅💪👂👃👀👅👄👶👦👧👱👨👩👴👵🙍🙎🙅🙆💁🙋🙇👮💂👷👸👳👲👰👼🎅💆💇🚶🏃💃👯🏂🏄🏊🛀👫💏💑👪👤👣🐵🐒🐶🐩🐺🐱🐯🐴🐎🐮🐷🐗🐽🐑🐫🐘🐭🐹🐰🐻🐨🐼🐾🐔🐣🐤🐥🐦🐧🐸🐢🐍🐲🐳🐬🐟🐠🐡🐙🐚🐌🐛🐜🐝🐞💐🌸💮🌹🌺🌻🌼🌷🌱🌴🌵🌾🌿🍀🍁🍂🍃🍇🍈🍉🍊🍌🍍🍎🍏🍑🍒🍓🍅🍆🌽🍄🌰🍞🍖🍗🍔🍟🍕🍳🍲🍱🍘🍙🍚🍛🍜🍝🍠🍢🍣🍤🍥🍡🍦🍧🍨🍩🍪🎂🍰🍫🍬🍭🍮🍯☕🍵🍶🍷🍸🍹🍺🍻🍴🔪🌏🗾🌋🗻🏠🏡🏢🏣🏥🏦🏨🏩🏪🏫🏬🏭🏯🏰💒🗼🗽⛪⛲⛺🌁🌃🌄🌅🌆🌇🌉♨️🎠🎡🎢💈🎪🚃🚄🚅🚇🚉🚌🚑🚒🚓🚕🚗🚙🚚🚲🚏⛽🚨🚥🚧⚓⛵🚤🚢✈️💺🚀⌛⏳⌚⏰🕛🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🌑🌓🌔🌕🌙🌛☀️⭐🌟🌠🌌☁️⛅🌀🌈🌂☔⚡❄️⛄🔥💧🌊🎃🎄🎆🎇✨🎈🎉🎊🎋🎍🎎🎏🎐🎑🎀🎁🎫🏆⚽⚾🏀🏈🎾🎳⛳🎣🎽🎿🎯🎱🔮🎮🎰🎲♠️♥️♦️♣️🃏🀄🎴🎭🎨👓👔👕👖👗👘👙👚👛👜👝🎒👞👟👠👡👢👑👒🎩🎓💄💍💎🔊📢📣🔔🎼🎵🎶🎤🎧📻🎷🎸🎹🎺🎻📱📲☎️📞📟📠🔋🔌💻💽💾💿📀🎥🎬📺📷📹📼🔍🔎💡🔦🏮📔📕📖📗📘📙📚📓📒📃📜📄📰📑🔖💰💴💵💸💳💹✉️📧📨📩📤📥📦📫📪📮✏️✒️📝💼📁📂📅📆📇📈📉📊📋📌📍📎📏📐✂️🔒🔓🔏🔐🔑🔨🔫🔧🔩🔗📡💉💊🚪🚽🚬🗿🏧♿🚹🚺🚻🚼🚾⚠️⛔🚫🚭🔞⬆️↗️➡️↘️⬇️↙️⬅️↖️↕️↔️↩️↪️⤴️⤵️🔃🔙🔚🔛🔜🔝🔯♈♉♊♋♌♍♎♏♐♑♒♓⛎▶️⏩◀️⏪🔼⏫🔽⏬🎦📶📳📴✖️➕➖➗‼️⁉️❓❔❕❗〰️💱💲♻️🔱📛🔰⭕✅☑️✔️❌❎➰〽️✳️✴️❇️©️®️™️#️⃣🔟🔠🔡🔢🔣🔤🅰️🆎🅱️🆑🆒🆓ℹ️🆔Ⓜ️🆕🆖🅾️🆗🅿️🆘🆙🆚🈁🈂️🈷️🈶🈯🉐🈹🈚🈲🉑🈸🈴🈳㊗️㊙️🈺🈵🔴🔵⚫⚪⬛⬜◼️◻️◾◽▪️▫️🔶🔷🔸🔹🔺🔻💠🔘🔳🔲🏁🚩🎌🇨🇳🇩🇪🇪🇸🇫🇷🇬🇧🇮🇹🇯🇵🇰🇷🇷🇺🇺🇸😐☹️🕳️🗯️🖐️✍️👁️🕵️🕴️⛷️🏌️⛹️🏋️🗣️🐕🐈🐿️🕊️🕷️🕸️🏵️🌶️🍽️🌍🌎🗺️🏔️⛰️🏕️🏖️🏜️🏝️🏞️🏟️🏛️🏗️🏘️🏚️⛩️🏙️🚍🚔🚘🏎️🏍️🛣️🛤️🛢️🛳️⛴️🛥️🛩️🛰️🛎️🕰️🕧🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🌜🌡️⛈️🌤️🌥️🌦️🌧️🌨️🌩️🌪️🌫️🌬️☂️⛱️☃️🎗️🎟️🎖️⛸️🕹️🖼️🕶️🛍️⛑️🔈🎙️🎚️🎛️🖥️🖨️🖱️🖲️🎞️📽️🕯️🗞️🏷️📬📭🗳️🖋️🖊️🖌️🖍️🗂️🗒️🗓️🖇️🗃️🗄️🗑️🗝️⛏️🛠️🗡️🛡️🗜️⛓️🛏️🛋️🕉️✡️☸️☯️✝️☪️⏭️⏮️⏸️⏹️⏺️🏳️😀🙂🙃😇😗😙😛🤑🤗🤔🤐😑😶🙄😬😴🤒🤕😎🤓😕😟🙁😮😯😦😧😈☠️🤖❣️👁️‍🗨️🗨️💭🖖🤘🖕🏇🚣🚴🚵🛌👭👬👩‍❤️‍💋‍👨👨‍❤️‍💋‍👨👩‍❤️‍💋‍👩👩‍❤️‍👨👨‍❤️‍👨👩‍❤️‍👩👨‍👩‍👦👨‍👩‍👧👨‍👩‍👧‍👦👨‍👩‍👦‍👦👨‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👩‍👩‍👦👩‍👩‍👧👩‍👩‍👧‍👦👩‍👩‍👦‍👦👩‍👩‍👧‍👧👥🦁🐅🐆🦄🐂🐃🐄🐖🐏🐐🐪🐁🐀🐇🦃🐓🐊🐉🐋🦂🌲🌳☘️🍋🍐🧀🌭🌮🌯🍿🦀🍼🍾🏺🌐🏤🕌🕍🕋🚂🚆🚈🚊🚝🚞🚋🚎🚐🚖🚛🚜🚦🛫🛬🚁🚟🚠🚡⏱️⏲️🌒🌖🌗🌘🌚🌝🌞☄️🏅🏐🏉🏏🏑🏒🏓🏸📿🔇🔉📯🔕⌨️📸💶💷⚒️⚔️🏹⚙️⚖️⚗️🔬🔭🚿🛁⚰️⚱️🚮🚰🛂🛃🛄🛅🚸🚳🚯🚱🚷📵☢️☣️🔄🛐⚛️☦️☮️🕎🔀🔁🔂⏯️⏏️🔅🔆⚜️➿*️⃣🏴🇦🇨🇦🇩🇦🇪🇦🇫🇦🇬🇦🇮🇦🇱🇦🇲🇦🇴🇦🇶🇦🇷🇦🇸🇦🇹🇦🇺🇦🇼🇦🇽🇦🇿🇧🇦🇧🇧🇧🇩🇧🇪🇧🇫🇧🇬🇧🇭🇧🇮🇧🇯🇧🇱🇧🇲🇧🇳🇧🇴🇧🇶🇧🇷🇧🇸🇧🇹🇧🇻🇧🇼🇧🇾🇧🇿🇨🇦🇨🇨🇨🇩🇨🇫🇨🇬🇨🇭🇨🇮🇨🇰🇨🇱🇨🇲🇨🇴🇨🇵🇨🇷🇨🇺🇨🇻🇨🇼🇨🇽🇨🇾🇨🇿🇩🇬🇩🇯🇩🇰🇩🇲🇩🇴🇩🇿🇪🇦🇪🇨🇪🇪🇪🇬🇪🇭🇪🇷🇪🇹🇪🇺🇫🇮🇫🇯🇫🇰🇫🇲🇫🇴🇬🇦🇬🇩🇬🇪🇬🇫🇬🇬🇬🇭🇬🇮🇬🇱🇬🇲🇬🇳🇬🇵🇬🇶🇬🇷🇬🇸🇬🇹🇬🇺🇬🇼🇬🇾🇭🇰🇭🇲🇭🇳🇭🇷🇭🇹🇭🇺🇮🇨🇮🇩🇮🇪🇮🇱🇮🇲🇮🇳🇮🇴🇮🇶🇮🇷🇮🇸🇯🇪🇯🇲🇯🇴🇰🇪🇰🇬🇰🇭🇰🇮🇰🇲🇰🇳🇰🇵🇰🇼🇰🇾🇰🇿🇱🇦🇱🇧🇱🇨🇱🇮🇱🇰🇱🇷🇱🇸🇱🇹🇱🇺🇱🇻🇱🇾🇲🇦🇲🇨🇲🇩🇲🇪🇲🇫🇲🇬🇲🇭🇲🇰🇲🇱🇲🇲🇲🇳🇲🇴🇲🇵🇲🇶🇲🇷🇲🇸🇲🇹🇲🇺🇲🇻🇲🇼🇲🇽🇲🇾🇲🇿🇳🇦🇳🇨🇳🇪🇳🇫🇳🇬🇳🇮🇳🇱🇳🇴🇳🇵🇳🇷🇳🇺🇳🇿🇴🇲🇵🇦🇵🇪🇵🇫🇵🇬🇵🇭🇵🇰🇵🇱🇵🇲🇵🇳🇵🇷🇵🇸🇵🇹🇵🇼🇵🇾🇶🇦🇷🇪🇷🇴🇷🇸🇷🇼🇸🇦🇸🇧🇸🇨🇸🇩🇸🇪🇸🇬🇸🇭🇸🇮🇸🇯🇸🇰🇸🇱🇸🇲🇸🇳🇸🇴🇸🇷🇸🇸🇸🇹🇸🇻🇸🇽🇸🇾🇸🇿🇹🇦🇹🇨🇹🇩🇹🇫🇹🇬🇹🇭🇹🇯🇹🇰🇹🇱🇹🇲🇹🇳🇹🇴🇹🇷🇹🇹🇹🇻🇹🇼🇹🇿🇺🇦🇺🇬🇺🇲🇺🇾🇺🇿🇻🇦🇻🇨🇻🇪🇻🇬🇻🇮🇻🇳🇻🇺🇼🇫🇼🇸🇽🇰🇾🇪🇾🇹🇿🇦🇿🇲🇿🇼🤣🤥🤤🤢🤧🤠🤡🖤🤚🤞🤙🤛🤜🤝🤳👱‍♀️👱‍♂️🙍‍♂️🙍‍♀️🙎‍♂️🙎‍♀️🙅‍♂️🙅‍♀️🙆‍♂️🙆‍♀️💁‍♂️💁‍♀️🙋‍♂️🙋‍♀️🙇‍♂️🙇‍♀️🤦🤦‍♂️🤦‍♀️🤷🤷‍♂️🤷‍♀️👨‍⚕️👩‍⚕️👨‍🎓👩‍🎓👨‍🏫👩‍🏫👨‍⚖️👩‍⚖️👨‍🌾👩‍🌾👨‍🍳👩‍🍳👨‍🔧👩‍🔧👨‍🏭👩‍🏭👨‍💼👩‍💼👨‍🔬👩‍🔬👨‍💻👩‍💻👨‍🎤👩‍🎤👨‍🎨👩‍🎨👨‍✈️👩‍✈️👨‍🚀👩‍🚀👨‍🚒👩‍🚒👮‍♂️👮‍♀️🕵️‍♂️🕵️‍♀️💂‍♂️💂‍♀️👷‍♂️👷‍♀️🤴👳‍♂️👳‍♀️🤵🤰🤶💆‍♂️💆‍♀️💇‍♂️💇‍♀️🚶‍♂️🚶‍♀️🏃‍♂️🏃‍♀️🕺👯‍♂️👯‍♀️🤺🏌️‍♂️🏌️‍♀️🏄‍♂️🏄‍♀️🚣‍♂️🚣‍♀️🏊‍♂️🏊‍♀️⛹️‍♂️⛹️‍♀️🏋️‍♂️🏋️‍♀️🚴‍♂️🚴‍♀️🚵‍♂️🚵‍♀️🤸🤸‍♂️🤸‍♀️🤼🤼‍♂️🤼‍♀️🤽🤽‍♂️🤽‍♀️🤾🤾‍♂️🤾‍♀️🤹🤹‍♂️🤹‍♀️👨‍👦👨‍👦‍👦👨‍👧👨‍👧‍👦👨‍👧‍👧👩‍👦👩‍👦‍👦👩‍👧👩‍👧‍👦👩‍👧‍👧🦍🦊🦌🦏🦇🦅🦆🦉🦎🦈🦋🥀🥝🥑🥔🥕🥒🥜🥐🥖🥞🥓🥙🥚🥘🥗🦐🦑🥛🥂🥃🥄🛵🛴🛑🛶🥇🥈🥉🥊🥋🥅🥁🛒♀️♂️⚕️🏳️‍🌈🇺🇳🤩🤪🤭🤫🤨🤮🤯🧐🤬🧡🤟🤲🧠🧒🧑🧔🧓🧕🤱🧙🧙‍♂️🧙‍♀️🧚🧚‍♂️🧚‍♀️🧛🧛‍♂️🧛‍♀️🧜🧜‍♂️🧜‍♀️🧝🧝‍♂️🧝‍♀️🧞🧞‍♂️🧞‍♀️🧟🧟‍♂️🧟‍♀️🧖🧖‍♂️🧖‍♀️🧗🧗‍♂️🧗‍♀️🧘🧘‍♂️🧘‍♀️🦓🦒🦔🦕🦖🦗🥥🥦🥨🥩🥪🥣🥫🥟🥠🥡🥧🥤🥢🛸🛷🥌🧣🧤🧥🧦🧢🏴󠁧󠁢󠁥󠁮󠁧󠁿🏴󠁧󠁢󠁳󠁣󠁴󠁿🏴󠁧󠁢󠁷󠁬󠁳󠁿🥰🥵🥶🥴🥳🥺🦵🦶🦷🦴👨‍🦰👨‍🦱👨‍🦳👨‍🦲👩‍🦰👩‍🦱👩‍🦳👩‍🦲🦸🦸‍♂️🦸‍♀️🦹🦹‍♂️🦹‍♀️🦰🦱🦳🦲🦝🦙🦛🦘🦡🦢🦚🦜🦟🦠🥭🥬🥯🧂🥮🦞🧁🧭🧱🛹🧳🧨🧧🥎🥏🥍🧿🧩🧸♟️🧵🧶🥽🥼🥾🥿🧮🧾🧰🧲🧪🧫🧬🧴🧷🧹🧺🧻🧼🧽🧯♾️🏴‍☠️🥱🤎🤍🤏🦾🦿🦻🧑‍🦰🧑‍🦱🧑‍🦳🧑‍🦲🧏🧏‍♂️🧏‍♀️🧑‍⚕️🧑‍🎓🧑‍🏫🧑‍⚖️🧑‍🌾🧑‍🍳🧑‍🔧🧑‍🏭🧑‍💼🧑‍🔬🧑‍💻🧑‍🎤🧑‍🎨🧑‍✈️🧑‍🚀🧑‍🚒🧍🧍‍♂️🧍‍♀️🧎🧎‍♂️🧎‍♀️🧑‍🦯👨‍🦯👩‍🦯🧑‍🦼👨‍🦼👩‍🦼🧑‍🦽👨‍🦽👩‍🦽🧑‍🤝‍🧑🦧🦮🐕‍🦺🦥🦦🦨🦩🧄🧅🧇🧆🧈🦪🧃🧉🧊🛕🦽🦼🛺🪂🪐🤿🪀🪁🦺🥻🩱🩲🩳🩰🪕🪔🪓🦯🩸🩹🩺🪑🪒🟠🟡🟢🟣🟤🟥🟧🟨🟩🟦🟪🟫🤵‍♂️🤵‍♀️👰‍♂️👰‍♀️👩‍🍼👨‍🍼🧑‍🍼🧑‍🎄🐈‍⬛🐻‍❄️")
}
