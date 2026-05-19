import 'package:flutter/material.dart';

class VotingResult {
  String name;
  int votes;
  Color color;

  VotingResult({required this.name, required this.votes, required this.color});
}

bool hasVotingData = true;

List<VotingResult> hasilKetos = [
  VotingResult(name: 'Seonghyeon', votes: 340, color: Color(0xFF3B82F6)),
  VotingResult(name: 'A-na', votes: 290, color: Color(0xFFEF4444)),
  VotingResult(name: 'James', votes: 220, color: Color(0xFFF59E0B)),
  VotingResult(name: 'Yuha', votes: 360, color: Color(0xFF10B981)),
];

List<VotingResult> hasilKetum = [
  VotingResult(name: 'Juhoon', votes: 340, color: Color(0xFF8B5CF6)),
  VotingResult(name: 'Carmen', votes: 290, color: Color(0xFFEC4899)),
  VotingResult(name: 'Keonho', votes: 220, color: Color(0xFF06B6D4)),
  VotingResult(name: 'Juun', votes: 360, color: Color(0xFFF97316)),
];