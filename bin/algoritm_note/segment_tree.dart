import 'dart:io';
import 'dart:math';

/// task name = Booking / solution type = дерево отрезков

bool debug = false;

int size = 1000000;
List<int> lazy = List.filled(size * 4, 0);
List<int> tree = List.filled(size * 4, 0);

void push(int v, int l, int r) {
  if (l < r) {
    lazy[v * 2] += lazy[v];
    lazy[v * 2 + 1] += lazy[v];
  }
  tree[v] += lazy[v];
  lazy[v] = 0;
}

int treeMax(int v, int l, int r, int ql, int qr) {
  if (debug) {
    print('max: $v $l $r $ql $qr');
  }
  if (l > qr || r < ql) {
    return 0;
  }
  push(v, l, r);
  if (l >= ql && r <= qr) {
    return tree[v];
  }

  int m = (l + r) ~/ 2;
  return max(
    treeMax(v * 2, l, m, ql, qr),
    treeMax(v * 2 + 1, m + 1, r, ql, qr),
  );
}

void treeInc(int v, int l, int r, int ql, int qr) {
  if (debug) {
    print('inc: $v $l $r $ql $qr');
  }
  if (l > qr || r < ql) {
    return;
  }
  if (l >= ql && r <= qr) {
    lazy[v]++;
    return;
  }

  push(v, l, r);
  int m = (l + r) ~/ 2;
  treeInc(v * 2, l, m, ql, qr);
  treeInc(v * 2 + 1, m + 1, r, ql, qr);
  tree[v] = max(tree[v * 2] + lazy[v * 2], tree[v * 2 + 1] + lazy[v * 2 + 1]);
}

void main() {
  solve();
}

void solve() {
  List<String> lines = File('input.txt').readAsLinesSync();
  final firstLine = lines[0].split(' ');
  //int n = int.parse(firstLine[0]);
  int s = int.parse(firstLine[1]);
  int t = int.parse(firstLine[2]);

  lines[1].split(' ').map((e) => int.parse(e)).forEach((a) {
    if (treeMax(1, 0, size, a, a + t - 1) >= s) {
      print("NO");
    } else {
      print("YES");
      treeInc(1, 0, size, a, a + t - 1);
    }
    if (debug) {
      print(tree);
      print(lazy);
    }
  });
}