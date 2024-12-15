#set page(
paper: "a4",
height: 297mm,
width: 210mm,
margin: (x: 1.5cm, y: 1.5cm),
)
 
#set par(
  justify: true,
  leading: 1em,
)
 
#set text(
  font: ("New Computer Modern","BIZ UDPMincho")
)
 
#show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(font: "BIZ UDPGothic") 
#set text(lang: "ja")
 
#set enum(numbering: "(1)",)
 
#import "@preview/colorful-boxes:1.2.0": *
 
#let my_block(back_color, frame_color, title_color, content_color, title, content) = {
  block(width:auto,radius: 4pt, stroke: back_color + 3pt)[
    #block(width: 100%,fill: back_color, inset: (x: 20pt, y: 5pt), below: 0pt)[#text(title_color,font: ("New Computer Modern","BIZ UDPMincho"))[#title]]
   #block(radius: (
    bottom: 3pt,
  ),width: 100%, fill: frame_color, inset: (x: 20pt, y: 10pt))[#text(content_color)[#content]]
  ]
}
 
#my_block(olive,rgb(95%, 100%, 95%) , white, black, [\@apu_yokaiさんより，正方形内に凸四角形ができる確率], [正方形の中にランダムに4つの点を打ったとき、それが凸四角形になる確率ってどのくらいなのかな 

 $ P(R) = 1-(4 overline(A_R))/A(R) = 1-(4 times 11/144)/1 = 1-11/36=bold(25/36) $
 ])

= Julia 言語で確認

100万回ランダムに４点とったときに，凸四角形が何回できるを確認。694,269回でした。

#import "@preview/codelst:2.0.2": sourcecode
#v(5mm)

#sourcecode[
```julia 
function count_conv(n)
    t = 0
    list = [(1,2,3,4),(2,3,4,1),(3,4,1,2),(4,1,2,3)]
    for i = 1:n
        A = [rand(2) for i = 1:4] #4点ランダム（一様乱数）にとる
        k = 0
        for l in list
            B = [
                1 1 1
                A[l[1]][1] A[l[2]][1] A[l[3]][1]
                A[l[1]][2] A[l[2]][2] A[l[3]][2]
            ]
            x = [
                1
                A[l[4]][1] 
                A[l[4]][2]
            ]
            y = B\x
            if all(i->(i>0),y)
                k += 1
            end
        end
        if k == 0
            t += 1
        end
    end
    t
end

n =10^6
count_conv(n)
```
]
```output
694269
```

#pagebreak()

= シルベスターの4点問題[1]
#v(5mm)


#image("222.png")

シルベスターの4点問題は、平面領域 $R$ 内でランダムに選ばれた4点の凸包が四角形になる確率 $q(R)$ を求める問題です（Sylvester, 1865）。平面内の点の選び方によって異なる解が得られるため、シルベスターはこの問題について「この問題は決定的な解を持たない」と結論付けました（Sylvester, 1865; Pfiefer, 1989）。
#v(5mm)

== 確率の一般式
#v(5mm)

 平面内の開かつ凸な有限領域 $R$ から点を選ぶ場合、四角形となる確率は次の式で与えられます：



  $ P(R) = 1-(4 overline(A_R))/A(R) $
#v(5mm)
ここで：
#v(5mm)
  - $overline(A_R)$ は、領域 $R$ 内の点から成る三角形の期待面積（平均面積）。
  - $A(R)$ は、領域 $R$ の面積。
#v(5mm)
 この式は、Efron（1965）によって示されました。

#v(5mm)

#pagebreak()
= 正方形内の三角形の選択問題（Square triangle picking）[2]
#v(5mm)

#figure(image("223.png"))

#v(5mm)

正方形内の三角形の選択問題（Square triangle picking）は、正方形内にランダムに配置された3点が決める三角形の集合を考える問題です。この問題では、単位正方形内でランダムに選ばれた3点が形成する三角形の平均面積を解析的に求めます。
#v(5mm)
== 平均面積の式
#v(5mm)
単位正方形内でランダムに3点を選んだ場合、形成される三角形の平均面積は以下の重積分によって表されます。分母は領域内で点を選ぶ全ての組み合わせを考慮しており、これは単位正方形の場合に1に正規化されます。そのため、最終的な平均面積は次の式で求められます：

#v(5mm)
$ // 平均面積の式
overline(A) &= frac(
    integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 abs(Delta) d x_1 d x_2 d x_3 d y_1 d y_2 d y_3,
    integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 d x_1 d x_2 d x_3 d y_1 d y_2 d y_3
)\
&= integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 integral_0^1 abs(Delta) d x_1 d x_2 d x_3 d y_1 d y_2 d y_3 $

#v(5mm)
== 三角形の符号付き面積
#v(5mm)
3つの点 $(x_1, y_1)$、$(x_2, y_2)$、$(x_3, y_3)$ による三角形の符号付き面積 $Delta$ は次の行列式で表されます。これを展開すると次の式となります。重積分の計算では、この面積の絶対値 $abs(Delta)$ を用います。
#v(5mm)
#set math.mat(delim: "|")
$ 
// 符号付き面積 Δ の定義
Delta = frac(1, 2!) 
mat(x_1, y_1, 1;
        x_2, y_2, 1;
        x_3, y_3, 1
        )
        == frac(1, 2) (
  -x_2y_1 + x_3y_1 + x_1y_2 - x_3y_2 - x_1y_3 + x_2y_3
  )
 $
#v(5mm)
  
#v(5mm)
== 計算の難しさと分割
#v(5mm)
この重積分を直接計算するのは非常に難しく、積分関数が複雑になります。このため、以下の手法を使用します：
#v(5mm)
	1.	円筒代数分解（Cylindrical Algebraic Decomposition, CAD）
領域を複数の部分領域に分割し、それぞれの領域内では  $Delta$  の符号が一定となるようにします。
	2.	部分領域ごとの積分
符号が一定の領域ごとに積分を計算し、最後に全ての結果を組み合わせます。
この方法では、変数の順序によって分割される領域の数が変わり、32から最大で4168の領域が得られます（Trott, 1998）。
#v(5mm)
== 結果
#v(5mm)
最終的に計算された単位正方形内での三角形の平均面積は次の値になります：
#v(5mm)

$ overline(A) = frac(11, 144)  $
#v(5mm)

これは、Woolhouse（1867）が最初に求めた結果であり、その後Ambartzumian（1987）、Pfiefer（1989）、Trott（1998）らが同じ結果を得ています。

#v(5mm)
= まとめ

#v(5mm)
 $ P(R) = 1-(4 overline(A_R))/A(R) = 1-(4 times 11/144)/1 = 1-11/36=bold(25/36) $
#v(5mm)



＜参考URL＞

[1] https://mathworld.wolfram.com/SylvestersFour-PointProblem.html

[2] https://mathworld.wolfram.com/SquareTrianglePicking.html



