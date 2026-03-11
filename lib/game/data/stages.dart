import 'stage_data.dart';
import 'stage2_data.dart';
import 'stage3_data.dart';
import 'stage4_data.dart';
import 'stage5_data.dart';
import 'stage6_data.dart';
import 'stage7_data.dart';
import 'stage8_data.dart';
import 'stage9_data.dart';
import 'stage10_data.dart';

final allStages = <StageData>[
  stage1, stage2, stage3, stage4, stage5,
  stage6, stage7, stage8, stage9, stage10,
];

StageData stageById(int id) => allStages.firstWhere((s) => s.id == id);
