//
//  TiModel.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

struct ExplainListModel: Codable {
    var QType: String! = ""
    var QContent: String! = ""
    enum CodingKeys: String, CodingKey {
        case QType, QContent
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        QType = try? container.decode(String.self, forKey: .QType)
        QContent = try? container.decode(String.self, forKey: .QContent)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(QType, forKey: .QType)
        try container.encode(QContent, forKey: .QContent)
    }
}
struct KaoDianListModel: Codable {
    var KaoDianId: String! = ""
    var KaoDianName: String! = ""
    enum CodingKeys: String, CodingKey {
        case KaoDianId, KaoDianName
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        KaoDianId = try? container.decode(String.self, forKey: .KaoDianId)
        KaoDianName = try? container.decode(String.self, forKey: .KaoDianName)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(KaoDianId, forKey: .KaoDianId)
        try container.encode(KaoDianName, forKey: .KaoDianName)
    }
}
struct SbjContentListModel: Codable {
    var QType: String! = ""
    var QContent: String! = ""
    enum CodingKeys: String, CodingKey {
        case QType, QContent
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        QType = try? container.decode(String.self, forKey: .QType)
        QContent = try? container.decode(String.self, forKey: .QContent)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(QType, forKey: .QType)
        try container.encode(QContent, forKey: .QContent)
    }
}
struct SbjChoiceModel: Codable {
    var Label: String! = ""
    var Text: String! = ""
    enum CodingKeys: String, CodingKey {
        case Label, Text
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Label = try? container.decode(String.self, forKey: .Label)
        Text = try? container.decode(String.self, forKey: .Text)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Label, forKey: .Label)
        try container.encode(Text, forKey: .Text)
    }
}
struct QuestionsModel: Codable {
    var IsLastError: String! = ""
    var DoCount: String! = ""
    var SbjNanDu: String! = ""
    var ExplainList: [ExplainListModel]?
    var SbjType: String! = ""
    var RightCount: String! = ""
    var SbjId: String! = ""
    var TiHao: String! = ""
    var Answer: String! = ""
    var KaoDianList: [KaoDianListModel]?
    var LanMuId: String! = ""
    var LastAnswer: String! = ""
    var QuanZhanZuoDa: String! = ""
    var YiCuoXiang: String! = ""
    var SbjContentList: [SbjContentListModel]?
    var FenXiangLianJie: String! = ""
    var UserAllCount: String! = ""
    var ShouCangId: String! = ""
    var QuanZhanRightRate: String! = ""
    var SbjTypeName: String! = ""
    var Score: String! = ""
    var SbjContent: String! = ""
    var SbjChoice: [SbjChoiceModel]?
    var UserRightCount: String! = ""
    var TypeLeiId: String! = ""
    var YongShiTime: String! = ""
    enum CodingKeys: String, CodingKey {
        case IsLastError, DoCount, SbjNanDu, ExplainList, SbjType, RightCount, SbjId, TiHao, Answer, KaoDianList, LanMuId, LastAnswer, QuanZhanZuoDa, YiCuoXiang, SbjContentList, FenXiangLianJie, UserAllCount, ShouCangId, QuanZhanRightRate, SbjTypeName, Score, SbjContent, SbjChoice, UserRightCount, TypeLeiId, YongShiTime
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        IsLastError = try? container.decode(String.self, forKey: .IsLastError)
        DoCount = try? container.decode(String.self, forKey: .DoCount)
        SbjNanDu = try? container.decode(String.self, forKey: .SbjNanDu)
        ExplainList = try? container.decode([ExplainListModel].self, forKey: .ExplainList)
        SbjType = try? container.decode(String.self, forKey: .SbjType)
        RightCount = try? container.decode(String.self, forKey: .RightCount)
        SbjId = try? container.decode(String.self, forKey: .SbjId)
        TiHao = try? container.decode(String.self, forKey: .TiHao)
        Answer = try? container.decode(String.self, forKey: .Answer)
        KaoDianList = try? container.decode([KaoDianListModel].self, forKey: .KaoDianList)
        LanMuId = try? container.decode(String.self, forKey: .LanMuId)
        LastAnswer = try? container.decode(String.self, forKey: .LastAnswer)
        QuanZhanZuoDa = try? container.decode(String.self, forKey: .QuanZhanZuoDa)
        YiCuoXiang = try? container.decode(String.self, forKey: .YiCuoXiang)
        SbjContentList = try? container.decode([SbjContentListModel].self, forKey: .SbjContentList)
        FenXiangLianJie = try? container.decode(String.self, forKey: .FenXiangLianJie)
        UserAllCount = try? container.decode(String.self, forKey: .UserAllCount)
        ShouCangId = try? container.decode(String.self, forKey: .ShouCangId)
        QuanZhanRightRate = try? container.decode(String.self, forKey: .QuanZhanRightRate)
        SbjTypeName = try? container.decode(String.self, forKey: .SbjTypeName)
        Score = try? container.decode(String.self, forKey: .Score)
        SbjContent = try? container.decode(String.self, forKey: .SbjContent)
        SbjChoice = try? container.decode([SbjChoiceModel].self, forKey: .SbjChoice)
        UserRightCount = try? container.decode(String.self, forKey: .UserRightCount)
        TypeLeiId = try? container.decode(String.self, forKey: .TypeLeiId)
        YongShiTime = try? container.decode(String.self, forKey: .YongShiTime)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(IsLastError, forKey: .IsLastError)
        try container.encode(DoCount, forKey: .DoCount)
        try container.encode(SbjNanDu, forKey: .SbjNanDu)
        try container.encode(ExplainList, forKey: .ExplainList)
        try container.encode(SbjType, forKey: .SbjType)
        try container.encode(RightCount, forKey: .RightCount)
        try container.encode(SbjId, forKey: .SbjId)
        try container.encode(TiHao, forKey: .TiHao)
        try container.encode(Answer, forKey: .Answer)
        try container.encode(KaoDianList, forKey: .KaoDianList)
        try container.encode(LanMuId, forKey: .LanMuId)
        try container.encode(LastAnswer, forKey: .LastAnswer)
        try container.encode(QuanZhanZuoDa, forKey: .QuanZhanZuoDa)
        try container.encode(YiCuoXiang, forKey: .YiCuoXiang)
        try container.encode(SbjContentList, forKey: .SbjContentList)
        try container.encode(FenXiangLianJie, forKey: .FenXiangLianJie)
        try container.encode(UserAllCount, forKey: .UserAllCount)
        try container.encode(ShouCangId, forKey: .ShouCangId)
        try container.encode(QuanZhanRightRate, forKey: .QuanZhanRightRate)
        try container.encode(SbjTypeName, forKey: .SbjTypeName)
        try container.encode(Score, forKey: .Score)
        try container.encode(SbjContent, forKey: .SbjContent)
        try container.encode(SbjChoice, forKey: .SbjChoice)
        try container.encode(UserRightCount, forKey: .UserRightCount)
        try container.encode(TypeLeiId, forKey: .TypeLeiId)
        try container.encode(YongShiTime, forKey: .YongShiTime)
    }
}
struct TiModel: Codable {
    var IsBaoCun: String! = ""
    var QuanZhanScore: String! = ""
    var Questions: [QuestionsModel]?
    var UserGroupId: String! = ""
    var YiZuoTiMuShu: String! = ""
    var PaperId: String! = ""
    var ShengYuShiJian: String! = ""
    var TimeLimit: String! = ""
    var BaoGaoFenXiangLianJie: String! = ""
    enum CodingKeys: String, CodingKey {
        case IsBaoCun, QuanZhanScore, Questions, UserGroupId, YiZuoTiMuShu, PaperId, ShengYuShiJian, TimeLimit, BaoGaoFenXiangLianJie
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        IsBaoCun = try? container.decode(String.self, forKey: .IsBaoCun)
        QuanZhanScore = try? container.decode(String.self, forKey: .QuanZhanScore)
        Questions = try? container.decode([QuestionsModel].self, forKey: .Questions)
        UserGroupId = try? container.decode(String.self, forKey: .UserGroupId)
        YiZuoTiMuShu = try? container.decode(String.self, forKey: .YiZuoTiMuShu)
        PaperId = try? container.decode(String.self, forKey: .PaperId)
        ShengYuShiJian = try? container.decode(String.self, forKey: .ShengYuShiJian)
        TimeLimit = try? container.decode(String.self, forKey: .TimeLimit)
        BaoGaoFenXiangLianJie = try? container.decode(String.self, forKey: .BaoGaoFenXiangLianJie)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(IsBaoCun, forKey: .IsBaoCun)
        try container.encode(QuanZhanScore, forKey: .QuanZhanScore)
        try container.encode(Questions, forKey: .Questions)
        try container.encode(UserGroupId, forKey: .UserGroupId)
        try container.encode(YiZuoTiMuShu, forKey: .YiZuoTiMuShu)
        try container.encode(PaperId, forKey: .PaperId)
        try container.encode(ShengYuShiJian, forKey: .ShengYuShiJian)
        try container.encode(TimeLimit, forKey: .TimeLimit)
        try container.encode(BaoGaoFenXiangLianJie, forKey: .BaoGaoFenXiangLianJie)
    }
}
struct ResponesModel: Codable {
    var data: TiModel?
    var code: Int! = 0
    var message: String! = ""
    enum CodingKeys: String, CodingKey {
        case data, code, message
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decode(TiModel.self, forKey: .data)
        code = try? container.decode(Int.self, forKey: .code)
        message = try? container.decode(String.self, forKey: .message)
    }
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }
}
