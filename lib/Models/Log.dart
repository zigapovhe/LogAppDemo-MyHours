
import 'dart:convert';

List<Log> logsFromJson(String str) => List<Log>.from(json.decode(str).map((x) => Log.fromJson(x)));

class Log {
  Log({
    this.note,
    this.date,
    this.duration,
    this.projectName,
    this.taskName,
    this.clientName,
    this.projectInvoiceMethod,
    this.projectArchived,
    this.taskArchived,
    this.running,
    this.times,
    this.status,
    this.invoiceId,
    this.projectId,
    this.taskId,
    this.billable,
    this.locked,
    this.expense,
    this.userId,
    this.amount,
    this.rate,
    this.laborCost,
    this.laborRate,
    this.billableHours,
    this.laborHours,
    this.tags,
    this.attachments,
    this.billableAmount,
    this.id,
  });

  String note;
  DateTime date;
  int duration;
  String projectName;
  String taskName;
  dynamic clientName;
  int projectInvoiceMethod;
  bool projectArchived;
  bool taskArchived;
  bool running;
  List times;
  int status;
  int invoiceId;
  int projectId;
  int taskId;
  bool billable;
  bool locked;
  double expense;
  int userId;
  double amount;
  double rate;
  double laborCost;
  double laborRate;
  double billableHours;
  double laborHours;
  List tags;
  List<dynamic> attachments;
  double billableAmount;
  int id;

  factory Log.fromJson(Map<String, dynamic> map) => Log(
    note: map["note"],
    date: DateTime.parse(map["date"]),
    duration: map["duration"],
    projectName: map["projectName"],
    taskName: map["taskName"],
    clientName: map["clientName"],
    projectInvoiceMethod: map["projectInvoiceMethod"],
    projectArchived: map["projectArchived"],
    taskArchived: map["taskArchived"],
    running: map["running"],
    times: List<Time>.from(map["times"].map((x) => Time.fromJson(x))),
    status: map["status"],
    invoiceId: map["invoiceId"],
    projectId: map["projectId"],
    taskId: map["taskId"],
    billable: map["billable"],
    locked: map["locked"],
    expense: map["expense"],
    userId: map["userId"],
    amount: map["amount"],
    rate: map["rate"],
    laborCost: map["laborCost"],
    laborRate: map["laborRate"],
    billableHours: map["billableHours"],
    laborHours: map["laborHours"],
    tags: List<Tag>.from(map["tags"].map((x) => Tag.fromJson(x))),
    attachments: List<dynamic>.from(map["attachments"].map((x) => x)),
    billableAmount: map["billableAmount"],
    id: map["id"],
  );
}

class Tag {
  Tag({
    this.name,
    this.hexColor,
    this.archived,
    this.dateArchived,
    this.id,
  });

  String name;
  String hexColor;
  bool archived;
  dynamic dateArchived;
  int id;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json["name"],
    hexColor: json["hexColor"],
    archived: json["archived"],
    dateArchived: json["dateArchived"],
    id: json["id"],
  );
}

class Time {
  Time({
    this.duration,
    this.startTime,
    this.endTime,
    this.running,
    this.id,
  });

  int duration;
  dynamic startTime;
  dynamic endTime;
  bool running;
  int id;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    duration: json["duration"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    running: json["running"],
    id: json["id"],
  );

}
