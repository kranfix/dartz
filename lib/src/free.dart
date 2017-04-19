part of dartz;

abstract class Free<F, A> extends FunctorOps<Free/*<F, dynamic>*/, A> with ApplicativeOps<Free/*<F, dynamic>*/, A>, MonadOps<Free/*<F, dynamic>*/, A> {

  @override Free<F, dynamic/*=B*/> pure/*<B>*/(/*=B*/ b) => new Pure(b);

  @override Free<F, dynamic/*=B*/> map/*<B>*/(/*=B*/ f(A a)) => bind((a) => new Pure(f(a)));

  @override Free<F, dynamic/*=B*/> bind/*<B>*/(Free<F, dynamic/*=B*/> f(A a)) => new Bind(this, f);

  /*=R*/ fold/*<R>*/(/*=R*/ ifPure(A a), /*=R*/ ifSuspend(F fa), /*=R*/ ifBind(Free<F, dynamic> ffb, Function1<dynamic, Free<F, A>> f));
/*
  Free<F, A> step() {
    Free<F, A> current = this;
    while(current is Bind) {
      final currentBind = cast/*<Bind<F, A, dynamic>>*/(current);
      current = currentBind.ffb.fold((a) => currentBind.f(a), (fa) => currentBind, (ffb, f) => ffb.bind((a) => f(a).bind((a2) => currentBind.f(a2))));
      if (identical(current, currentBind)) {
        return current;
      }
    }
    return current;
  }
*/
  /*=MA*/ foldMap/*<M, MA extends M>*/(Monad/*<M>*/ m, /*=M*/ f(F fa)) =>
      cast(/*step().*/fold((a) => m.pure(a), (fa) => f(fa), (ffb, f2) => m.bind(ffb.foldMap(m, f), (c) => f2(c).foldMap(m, f))));

  @override Free<F, dynamic/*=B*/> flatMap/*<B>*/(Free<F, dynamic/*=B*/> f(A a)) => new Bind(this, f);
  @override Free<F, dynamic/*=B*/> andThen/*<B>*/(Free<F, dynamic/*=B*/> next) => bind((_) => next);
  @override Free<F, A> operator <<(Free<F, dynamic> next) => bind((a) => next.map((_) => a));
}

class Pure<F, A> extends Free<F, A> {
  final A a;
  Pure(this.a);
  /*=R*/ fold/*<R>*/(/*=R*/ ifPure(A a), /*=R*/ ifSuspend(F fa), /*=R*/ ifBind(Free<F, dynamic> ffb, Function1<dynamic, Free<F, A>> f)) => ifPure(a);
}

class Suspend<F, A> extends Free<F, A> {
  final F/**<A>**/ fa;
  Suspend(this.fa);
  /*=R*/ fold/*<R>*/(/*=R*/ ifPure(A a), /*=R*/ ifSuspend(F fa), /*=R*/ ifBind(Free<F, dynamic> ffb, Function1<dynamic, Free<F, A>> f)) => ifSuspend(fa);
}

class Bind<F, A, B> extends Free<F, A> {
  final Free<F, B> ffb;
  final Function1<B, Free<F, A>> f;
  Bind(this.ffb, this.f);
  /*=R*/ fold/*<R>*/(/*=R*/ ifPure(A a), /*=R*/ ifSuspend(F fa), /*=R*/ ifBind(Free<F, dynamic> ffb, Function1<dynamic, Free<F, A>> f)) => ifBind(ffb, f);
}

class FreeMonad<F> extends MonadOpsMonad<Free<F, dynamic>> {
  FreeMonad(): super((a) => new Pure(a));

  @override Free<F, dynamic/*=A*/> pure/*<A>*/(/*=A*/ a) => new Pure(a);

  @override Free<F, dynamic/*=C*/> map2/*<A, A2 extends A, B, B2 extends B, C>*/(Free<F, dynamic/*=A2*/> fa, Free<F, dynamic/*=B2*/> fb, /*=C*/ fun(/*=A*/ a, /*=B*/ b)) =>
      fa.flatMap((a) => fb.map((b) => fun(a, b)));

  @override Free<F, dynamic/*=D*/> map3/*<A, A2 extends A, B, B2 extends B, C, C2 extends C, D>*/(Free<F, dynamic/*=A2*/> fa, Free<F, dynamic/*=B2*/> fb, Free<F, dynamic/*=C2*/> fc, /*=D*/ fun(/*=A*/ a, /*=B*/ b, /*=C*/ c)) =>
      fa.flatMap((a) => fb.flatMap((b) => fc.map((c) => fun(a, b, c))));

  @override Free<F, dynamic/*=E*/> map4/*<A, A2 extends A, B, B2 extends B, C, C2 extends C, D, D2 extends D, E>*/(Free<F, dynamic/*=A2*/> fa, Free<F, dynamic/*=B2*/> fb, Free<F, dynamic/*=C2*/> fc, Free<F, dynamic/*=D2*/> fd, /*=E*/ fun(/*=A*/ a, /*=B*/ b, /*=C*/ c, /*=D*/ d)) =>
      fa.flatMap((a) => fb.flatMap((b) => fc.flatMap((c) => fd.map((d) => fun(a, b, c, d)))));

  @override Free<F, dynamic/*=FF*/> map5/*<A, A2 extends A, B, B2 extends B, C, C2 extends C, D, D2 extends D, E, E2 extends E, FF>*/(Free<F, dynamic/*=A2*/> fa, Free<F, dynamic/*=B2*/> fb, Free<F, dynamic/*=C2*/> fc, Free<F, dynamic/*=D2*/> fd, Free<F, dynamic/*=E2*/> fe, /*=FF*/ fun(/*=A*/ a, /*=B*/ b, /*=C*/ c, /*=D*/ d, /*=E*/ e)) =>
      fa.flatMap((a) => fb.flatMap((b) => fc.flatMap((c) => fd.flatMap((d) => fe.map((e) => fun(a, b, c, d, e))))));

  @override Free<F, dynamic/*=G*/> map6/*<A, A2 extends A, B, B2 extends B, C, C2 extends C, D, D2 extends D, E, E2 extends E, FF, F2 extends FF, G>*/(Free<F, dynamic/*=A2*/> fa, Free<F, dynamic/*=B2*/> fb, Free<F, dynamic/*=C2*/> fc, Free<F, dynamic/*=D2*/> fd, Free<F, dynamic/*=E2*/> fe, Free<F, dynamic/*=F2*/> ff, /*=G*/ fun(/*=A*/ a, /*=B*/ b, /*=C*/ c, /*=D*/ d, /*=E*/ e, /*=FF*/ f)) =>
      fa.flatMap((a) => fb.flatMap((b) => fc.flatMap((c) => fd.flatMap((d) => fe.flatMap((e) => ff.map((f) => fun(a, b, c, d, e, f)))))));

}

final FreeMonad FreeM = new FreeMonad();
FreeMonad/*<F>*/ freeM/*<F>*/() => FreeM as dynamic/*=FreeMonad<F>*/;

Free/*<F, A>*/ liftF/*<F, A>*/(/*=F*/ fa) => new Suspend(fa);
