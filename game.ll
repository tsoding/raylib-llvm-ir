; ModuleID = 'main.c'
target triple = "x86_64-pc-linux-gnu"

@title = constant [17 x i8] c"Hello, from LLVM\00"
@width = constant i32 100
@height = constant i32 100

define void @update(i32* %x, i32* %dx, i32 %w) {
  %vx = load i32, i32* %x
  %vdx = load i32, i32* %dx
  %x1 = add nsw i32 %vx, %vdx

  %1 = icmp slt i32 %x1, 0
  %2 = icmp sgt i32 %x1, %w
  %3 = or i1 %1, %2
  br i1 %3, label %update-dx, label %update-x
update-dx:
  %vdx1 = sub nuw i32 0, %vdx
  store i32 %vdx1, i32* %dx
  ret void
update-x:
  store i32 %x1, i32* %x
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() {
  %x = alloca i32
  %y = alloca i32
  %dx = alloca i32
  %dy = alloca i32
  store i32 200, i32* %x
  store i32 100, i32* %y
  store i32 1, i32* %dx
  store i32 1, i32* %dy
  call void @InitWindow(i32 800, i32 600, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @title, i64 0, i64 0))
  br label %cond
cond:
  %check = call i1 @WindowShouldClose()
  br i1 %check, label %over, label %body
body:
  call void @BeginDrawing()
  call void @ClearBackground(i32 u0xFF181818)

  %vx = load i32, i32* %x
  %vy = load i32, i32* %y
  %vdx = load i32, i32* %dx
  %vdy = load i32, i32* %dy
  call void @DrawRectangle(i32 %vx, i32 %vy, i32 100, i32 100, i32 u0xFF5555FF)
  call void @update(i32* %x, i32* %dx, i32 700)
  call void @update(i32* %y, i32* %dy, i32 500)

  call void @EndDrawing()
  br label %cond
over:
  call void @CloseWindow()
  ret i32 0
}

declare void @InitWindow(i32 noundef, i32 noundef, i8* noundef)
declare void @CloseWindow()
declare void @BeginDrawing()
declare void @EndDrawing()
declare void @ClearBackground(i32)
declare i1 @WindowShouldClose()
declare void @DrawRectangle(i32, i32, i32, i32, i32)
