/* Dit programma is geschreven door:
 * Edwin Spee, E-mail: info@epsig.nl, (c) 2001 - 2020.
 * Dit spel mag onbeperkt vaak gespeeld worden.
 * Alle overige rechten uitdrukkelijk voorbehouden.
 * Dit programma staat alleen legaal op:
 *  URL: https://www.epsig.nl/
 * De Javascript-broncode is versleuteld om oneigenlijk gebruik te voorkomen.
 * De oorspronkelijke broncode staat op: github.com/epsig/shob .
 */
var versie="6.2";
var dd="04 sep 2020";
var env,
matchadm,
vM=["Klaver","Ruiten","Schoppen","Harten"],
KRHS=["K","R","S","H"],
vN=["Jij","Links","Maat","Rechts"],
vO=["j","l","m","r"];
function mT(x){return mU(x)+"terdam";}
function mU(x){return x?"Ams":"Rot";}
function NieuwSpel()
{if(env.gfx())
{matchadm.NieuwSpel();}
else
{window.location.reload();}
}
function IncSpelNiveau(i)
{env.IncNiveau(i);
matchadm.strat.reset(env.niveau());}
function HelpFunctie(i)
{matchadm.help.HelpFunctie(i);}
function KiesTroef(i)
{matchadm.KiesTroef(i);}
function sN(i)
{matchadm.sN(i);}
function s3()
{matchadm.s3();}
function lK(i)
{matchadm.lK(i);}
function SpeelDeze(lJ)
{matchadm.SpeelDeze(lJ);}
function StartSpel()
{
env=new OEnvironment(document.BSpelNiveau);
matchadm=new OMatchAdmin(env);
if(matchadm.scrn.gfx){sR(0,0);}
else{matchadm.mB=0;matchadm.NieuwSpel();}
}
function setCookie(name,value){
var l0=new Date();
var l1=new Date(l0.getTime()+2419200000);
if(value!=null&&value!="")
document.cookie=name+"="+escape(value)+";expires="+l1.toGMTString();
}
function getCookie(name){
var l2=document.cookie;
var l6=l2.indexOf(name+"=");
if(l6==-1)return null;
l6=l2.indexOf("=",l6)+1;
var lO=l2.indexOf(";",l6);
if(lO==-1)lO=l2.length;
return unescape(l2.substring(l6,lO));
}
function OTimer(){
var start=new Date;
var stop=null;
this.tooktime=-1;
this.starttimer=function()
{
start=new Date;
this.tooktime=-1;
}
this.stoptimer=function()
{
stop=new Date;
this.tooktime=stop.getTime()-start.getTime();
}
}
function OHelp(adm){
var m_adm=adm;
var m9,mA;
this.nN=function()
{if(m_adm.mV.vX==8)
{m9="Je moet je laatste kaart opleggen.";
mA="";
return;
}
m9 = 'Je moet een kaart opleggen: ';
var lM=m_adm.br.s1(0);
if(lM[0]==1)
{mA="Je moet "+m_adm.mV.c.vV[lM[1]].naam+" opleggen.";}
else if(lM[0]==(9-m_adm.mV.vX))
{m9='Je moet een (willekeurige) kaart opleggen.';
var tip=m_adm.strat.mN(0);
mA = 'Tip: '+ m_adm.mV.c.vV[tip].naam;
}else
{mA = 'Je mag kiezen uit: ';
for(var i=0;i<8;i++)
{if(m_adm.br.bK(i))
{mA+=m_adm.mV.c.vV[i].naam+";";
}}
var tip=m_adm.strat.mN(0);
mA += ' Tip: '+ m_adm.mV.c.vV[tip].naam;
}}
this.nO=function()
{var m2=false;
m9="Je moet uitkomen.";
mA = 'Hoogste van een kleur: ';
for(var i=0;i<8;i++)
{var c=m_adm.mV.c.vV[i];
if(!c.m8&&c.s8())
{mA+=c.naam+";";
m2=true;
}}
if(!m2)
{var tip =  m_adm.strat.mM(0, 'help');
mA = 'tip: ' + m_adm.mV.c.vV[tip].naam;
}
}
this.nP=function()
{m9="Je moet troef kiezen.";
var t = m_adm.strat.KiesTroef(0, 'help');
mA = 'Kies bijvoorbeeld: ' +vM[t[0]];
}
this.HelpFunctie=function(bF)
{
var mB=m_adm.mB,
a="Dit klavarjasspel is geschreven door Edwin Spee.",
b='Opmerkingen ontvang ik graag per E-mail: info@epsig.nl';
c='Versie: ' + versie + ' d.d. ' + dd;
m_adm.mB=-1;
if(mB==-2)
{clearTimeout(m_adm.vF);}
else if(mB==-1)
{return;}
if(bF==1)
{if(mB==1||mB==3)
{if(m_adm.mV.g3>0){this.nN();}
else{this.nO();}
}else if(mB==2)
{this.nP();
}else
{
m9=a;
mA=b+"\n"+c;
}
if(m_adm.scrn.g2&&mB!=-2)
{
m_adm.scrn.sE(0,m9);
m_adm.scrn.sE(1,mA);
}
else
{
m_adm.scrn.msg(m9+"\n"+mA);
}}
else if(bF==2)
{m_adm.scrn.msg(a+"\n"+b+"\n"+c);}
else if(bF==3)
{m_adm.scrn.msg("Je twee tegenstanders spelen op drie niveau's." +
"\nOp niveau 1 wordt netjes volgens de regels gespeeld."+
"\nOp niveau 2 wordt bij uitkomen een beetje nagedacht."+
"\nOp niveau 3 wordt ook bij het bijleggen een beetje nagedacht.");}
else if(bF==4)
{this.m6(1);}
if(mB==-2)
{s3();
}else
{m_adm.mB=mB;}
}
this.m6=function(b)
{var m2,m4=false,m7;
var sZ=(b==1
?"Overzicht slagen dit spel:"
: 'Vorig potje: (troef = ' + vM[m_adm.mV.vZ] + ")");
var m5=sZ+"\n";
for(var i=1;i<=8;i++)
{m2=false;
m7="";
for(var j=0;j<4;j++)
{for(var k=0;k<32;k++)
{var c=m_adm.mV.c.vV[k];
if(c.m8&&c.slag==i&&c.n6==j)
{m2=true;
m4=true;
m7+=vO[Math.floor(k/8)]+":"+c.naam+";";
break;
}}}
if(m2)
{m5 += "Slag " + i + ': ' + m7 + ((m_adm.scrn.g2 || i%2==0) ? "\n":" ");
sZ+="Slag_"+i+":"+m7+" ";
}else{break;}}
if(b==2)
{m_adm.sT=m5+"\n";
setCookie("kj_log",sZ);
return;}
if(!m4)
{m5+="nog geen kaarten gespeeld.\n";}
else
{if(!m_adm.scrn.g2)
{m5+=m_adm.score.tussenstand();
}}
if(m_adm.scrn.g2){m5=m_adm.sT+m5;}
m_adm.scrn.msg(m5);
}
}
function OSetAnalyse(adm,nI,env,bD){
var niveau=env.niveau();
var m_adm=adm;
var troef=m_adm.mV.vZ;
var vV=adm.mV.c.vV;
var aR=niveau;
var aX=1-niveau;
var aS=Math.pow(10,aX);
var nrm=1.0;
var kk=new Array(4*32);
var virtual=[null,null,null,null];
var cnt_virtual=0;
var total=[0,0,0,0];
var aK=[0,0,0,0];
var aI=[0,0,0,0];
var aJ=[0,0,0,0];
var aG=new Array(9);
this.aD=function()
{
var i,j;
for(j=0;j<32;j++)
{var cnt=0;
for(i=0;i<4;i++)
{if(i!=nI&&kk[j+32*i])
{cnt+=1;
}}
if(cnt)
{for(i=0;i<4;i++)
{var perc=nrm/cnt;
if(i!=nI&&kk[j+32*i])
{kk[j+32*i]=perc;
}}}}
total=[0,0,0,0];
aK=[0,0,0,0];
aI=[0,0,0,0];
aJ=[0,0,0,0];
for(i=0;i<4;i++)
{for(j=0;j<8;j++)
{if(!vV[j+8*i].m8)
{total[i]++;
}}}
for(i=0;i<4;i++)
{if(i!=nI)
{for(j=0;j<32;j++)
if(kk[j+32*i]==nrm)
{aK[i]++;
}
else if(kk[j+32*i]>0)
{aI[i]++;
aJ[i]+=kk[j+32*i];
}}}
var m2=false;
for(i=0;i<4;i++)
{if(i!=nI)
{if(total[i]==aK[i])
{for(j=0;j<32;j++)
{if(kk[j+32*i]>0&&kk[j+32*i]<nrm)
{m2=true;
kk[j+32*i]=0;
}}}
else if(total[i]==aK[i]+aI[i])
{m2=true;
for(j=0;j<32;j++)
{if(kk[j+32*i]>0&&kk[j+32*i]<nrm)
{for(var ii=0;ii<4;ii++)
{if(i!=ii&&ii!=nI)
{kk[j+32*ii]=0;
}}
kk[j+32*i]=nrm;
}}}
}}
if(m2)
{
m2=false;
for(i=0;i<4*32;i++)
{if(kk[i]>0&&kk[i]<nrm)
{m2=true;
}}}
return m2;
}
this.aB=function()
{var i,j,k,it,bB=999,aZ;
bA:
for(it=1;it<=aR;it++)
{aJ=[0,0,0,0];
for(i=0;i<4;i++)
{if(i!=nI)
{for(j=0;j<32;j++)
{if(kk[j+32*i]!=nrm&&kk[j+32*i]>0)
{aJ[i]+=kk[j+32*i];
}}}}
aZ=true;
for(i=0;i<aR;i++)
{if(i!=nI&&aJ[i])
{bB=nrm*(total[i]-aK[i])/aJ[i];
if(Math.abs(1.0-bB)>aS)
{aZ=false;
for(j=0;j<32;j++)
{if(kk[j+32*i]>0&&kk[j+32*i]<nrm)
{kk[j+32*i]*=bB;
}}}}}
for(k=0;k<32;k++)
{var bE=0;
for(i=0;i<4;i++)
{if(i!=nI)
{bE+=kk[k+32*i];
}}
if(bE!=0&&(Math.abs(bE-nrm)>aS*nrm))
{bB=nrm/bE;
aZ=false;
for(i=0;i<4;i++)
{if(i!=nI)
{kk[k+32*i]*=bB;
}}}}
if(aZ){break bA;}
}
}
this.aC=function(s,si)
{var i,j,pf=-1,hf=-1;
var k=aG[s];
for(i=0;i<32;i++)
{
var c=vV[i];
if(c.m8&&c.slag==s&&c.c==troef&&c.n6<si)
{
k=troef;
}}
for(i=0;i<32;i++)
{
var c=vV[i];
if(c.m8&&c.slag==s&&c.c==k&&c.h()>hf&&c.n6<si)
{
hf=c.h();
pf=i;
}}
return pf;
}
this.aA=function()
{
var i,j,k,l;
for(i=0;i<32;i++)
{var c=vV[i];
if(c.m8&&c.n6==0)
{aG[c.slag]=c.c;
}}
for(i=0;i<4*32;i++)
{kk[i]=1;
}
for(i=8*nI;i<8*nI+8;i++)
{for(j=0;j<4;j++)
{kk[vV[i].aT+32*j]=0;
}}
for(i=0;i<32;i++)
{if(vV[i].m8)
{for(j=0;j<4;j++)
{kk[vV[i].aT+32*j]=0;
}}}
for(i=0;i<4;i++)
{if(i!=nI)
{for(j=0;j<8;j++)
{var aV=vV[j+8*i];
if(aV.m8&&aV.n6>0)
{
var knr=this.aC(aV.slag,aV.n6);
var aY=vV[knr];
var aU=aY.h();
var aW=aG[aV.slag];
if(aV.c!=aW)
{
{for(k=0;k<8;k++)
{kk[k+32*i+8*aW]=0;
}
}
if(aV.c!=troef&&aW!=troef)
{
var p=Math.floor(knr/8);
if(Math.abs(p-i)!=2||!m_adm.vW)
{if(aY.c==troef)
{
for(l=0;l<8;l++)
{if(m_adm.br.vG(l)>aU)
{kk[l+32*i+8*troef]=0;
}}}
else
{
for(l=0;l<8;l++)
{kk[l+32*i+8*troef]=0;
}}
}
}
}
if(aV.c==troef&&aW==troef)
{
if(aV.h()<aU)
{for(l=0;l<8;l++)
{
if(m_adm.br.vG(l)>aU)
{
kk[l+32*i+8*troef]=0;
}}
}}
if(aV.c==troef&&aW!=troef)
{
if(aY.c==troef&&aV.h()<aU)
{
for(l=0;l<8;l++)
{
for(var kl=0;kl<4;kl++)
{if(kl==troef)
{if(m_adm.br.vG(l)>aU)
{
kk[l+32*i+8*troef]=0;
}}
else
{
kk[l+32*i+8*kl]=0;
}}}}}
}
}}}
for(i=0;i<aR;i++)
{
if(!this.aD()){break;}
}
this.aB();
}
this.kans_bekennen=function(s,kl)
{
var p=1.0;
for(k=0;k<8;k++)
{
p*=1.0-kk[k+32*s+8*kl];
}
return 1.0-p;
}
this.kans_hoger_dubbel=function(s,kl,sll_bekend,slm_bekend,sll_troef,slm_troef)
{
var mag1=new Array(32);
var mag2=new Array(32);
if(kl==troef){sll_troef=0;slm_troef=0;}
for(var i=0;i<32;i++)
{
var kleur_i=Math.floor(i/8);
if(kleur_i==kl)
{
mag1[i]=1.0;
mag2[i]=1.0;
}
else if(kleur_i==troef&&troef!=kl)
{
mag1[i]=1.0-sll_bekend;
mag2[i]=1.0-slm_bekend;
}
else
{
mag1[i]=1.0-sll_bekend-(1.0-sll_bekend)*sll_troef;
mag2[i]=1.0-slm_bekend-(1.0-slm_bekend)*slm_troef;
}
}
var sll=(s+1)%4;
var p=0.0;
var norm=0.0;
var E_roem=0.0;
for(var k=0;k<32;k++)
{
var has=mag1[k]*kk[k+32*s];
if(has)
{
var kleur_k=Math.floor(k/8);
var tmp=new o(k+7-8*kleur_k,kleur_k,m_adm.mV.c,m_adm);
tmp.settroef(troef);
m_adm.mV.VirtueleZet(s,tmp,this);
for(var k2=0;k2<32;k2++)
{
var has2=mag2[k2]*kk[k2+32*sll];
if(has2&&k!=k2)
{
var kleur_k2=Math.floor(k2/8);
var tmp2=new o(k2+7-8*kleur_k2,kleur_k2,m_adm.mV.c,m_adm);
tmp2.settroef(troef);
m_adm.mV.VirtueleZet(sll,tmp2,this);
var lB=m_adm.br.sA();
var roem=m_adm.br.mK();
m_adm.mV.WisVirtueleZet(sll,this);
if((lB%2)==(s%2)){p+=has*has2;}
norm+=has*has2;
E_roem+=has*has2*((lB%2)==(s%2)?roem:-roem);
}
}
m_adm.mV.WisVirtueleZet(s,this);
}
}
return[p/norm,E_roem];
}
this.kans_hoger=function(s,kl,sll_bekend,sll_troef)
{
var mag1=new Array(32);
if(kl==troef){sll_troef=0;}
for(var i=0;i<32;i++)
{
var kleur_i=Math.floor(i/8);
if(kleur_i==kl)
{
mag1[i]=1.0;
}
else if(kleur_i==troef&&troef!=kl)
{
mag1[i]=1.0-sll_bekend;
}
else
{
mag1[i]=1.0-sll_bekend-(1.0-sll_bekend)*sll_troef;
}
}
var sll=(s+1)%4;
var p=0.0;
var norm=0.0;
var E_roem=0.0;
for(var k=0;k<32;k++)
{
var has=mag1[k]*kk[k+32*s];
if(has)
{
var kleur_k=Math.floor(k/8);
var tmp=new o(k+7-8*kleur_k,kleur_k,m_adm.mV.c,m_adm);
tmp.settroef(troef);
m_adm.mV.VirtueleZet(s,tmp,this);
var lB=m_adm.br.sA();
var roem=m_adm.br.mK();
if((lB%2)==(s%2)){p+=has;}
norm+=has;
E_roem+=has*((lB%2)==(s%2)?roem:-roem);
m_adm.mV.WisVirtueleZet(s,this);
}
}
return[p/norm,E_roem];
}
this.VirtueleZet=function(s,c)
{
virtual[s]=c;
cnt_virtual++;
}
this.WisVirtueleZet=function(s)
{
virtual[s]=null;
cnt_virtual--;
}
this.aA();
this.perc=function(color,player,i){return kk[32*player+8*color+i];}
}
function o(l7,lP,c,adm){
var vV=c.vV;
var m_adm=adm;
var istroef;
this.s8=function()
{var vK=this.h();
for(var i=0;i<32;i++)
{
var cmp=vV[i];
if(!cmp.m8&&cmp.c==this.c&&cmp.h()>vK)
{return false;}
}
return true;
}
this.h=function()
{return(istroef)?m_adm.br.vG(this.mH-7):m_adm.br.vH(this.mH-7);}
this.p=function()
{return(istroef)?m_adm.br.vI(this.mH-7):m_adm.br.vJ(this.mH-7);}
this.sL=function(vX,nI,g3)
{
this.m8=true;
this.slag=vX;
this.n6=(4+nI-g3)%4;
}
this.reset=function()
{
this.m8=false;
this.slag=-1;
this.n6=-1;
}
this.settroef=function(k)
{
istroef=(this.c==k);
}
this.init=function()
{
this.mH=l7;
this.c=lP;
this.aT=8*lP+l7-7;
this.naam=KRHS[lP]+m_adm.br.nm(l7-7);
if(m_adm.scrn.gfx)
{
this.nG=new Image(50,50);
this.nG.onLoad="m1(1);";
this.nG.src="include/"+this.naam+".gif";
}
this.reset();
}
this.init();
}
function OBasicRules(ar){
var bG=[0,1,6,4,7,2,3,5];
var bH=[0,1,2,6,3,4,5,7];
var bI=[0,0,14,10,20,3,4,11];
var bJ=[0,0,0,10,2,3,4,11];
var Cnm=["-7","-8","-9","10","-B","-V","-H","-A"];
var amsrot=ar;
var mV=null;
var vV=null;
var v3=null;
var v6=null;
var v1=new Array(8);
this.bK=function(i){return v1[i];}
this.vG=function(i){return bG[i];}
this.vH=function(i){return bH[i];}
this.vI=function(i){return bI[i];}
this.vJ=function(i){return bJ[i];}
this.nm=function(i){return Cnm[i];}
var lA;
var nI;
this.s2=function(lD)
{var mx=-1,n9,j;
for(j=0;j<4;j++)
{if(v6[j])
{
var cmp=v3[j];
if(cmp.c==lD&&cmp.h()>mx)
{mx=cmp.h();
n9=j;
}}}
return(mx!=-1?n9:-1);
}
this.sA=function()
{
var n9=this.s2(mV.vZ);
return(n9!=-1)?n9:this.s2(mV.g1);
}
this.n3=function()
{var i,m2=0,lC=0;
for(i=8*nI;i<8*nI+8;i++)
{
var cmp=vV[i];
if(cmp.c==mV.vZ&&!cmp.m8&&cmp.h()>lA)
{m2++;
v1[i-8*nI]=true;
lC=i;
}}
return[m2,lC];
}
this.n1=function()
{var i,m2=0,lC=0;
for(i=8*nI;i<8*nI+8;i++)
{
var cmp=vV[i];
if(cmp.c==mV.g1&&!cmp.m8)
{m2++;
v1[i-8*nI]=true;
lC=i;
}}
return[m2,lC];
}
this.s6=function()
{var i,m2=0,lC=0;
for(i=8*nI;i<8*nI+8;i++)
{
var cmp=vV[i];
if(cmp.c!=mV.g1&&cmp.c!=mV.vZ&&!cmp.m8)
{m2++;
v1[i-8*nI]=true;
lC=i;
}}
return[m2,lC];
}
this.n7=function()
{var i,m2=0,lC=0;
for(i=8*nI;i<8*nI+8;i++)
{
var cmp=vV[i];
if(cmp.c==mV.vZ&&!cmp.m8&&cmp.h()<lA)
{m2++;
v1[i-8*nI]=true;
lC=i;
}}
return[m2,lC];
}
this.n2=function()
{var i,m2=0,lC=0;
for(i=8*nI;i<8*nI+8;i++)
{if(!vV[i].m8)
{m2++;
v1[i-8*nI]=true;
lC=i;
}}
return[m2,lC];
}
this.sB=function()
{var m2=this.n3();
if(m2[0]!=0)return m2;
m2=this.n7();
if(m2[0]!=0)return m2;
return this.n2();
}
this.sC=function()
{var m2=this.n1();
if(m2[0]!=0)return m2;
var m3=this.n3(),m4=this.s6();
m2=m3[0]+m4[0];
if(m2==0)return this.n7();
return[m2,m2==1?m3[1]+m4[1]:0];
}
this.sD=function()
{var m2=this.n1();
if(m2[0]!=0)return m2;
m2=this.n3();
if(m2[0]!=0)return m2;
m2=this.s6();
if(m2[0]!=0)return m2;
return this.n7();
}
this.s1=function(s)
{
nI=s;
var i,lE,nA=this.sA();
if(mV.vZ==mV.g1)
{lE=1;}
else
{if(amsrot)
{lE=(nA==nI+2||nA==nI-2)?2:3;}
else
{lE=4;}
}
for(i=0;i<8;i++){v1[i]=false;}
var coth=v3[nA];
lA=(coth.c==mV.vZ?coth.h():-1);
if(lE==1)
{return this.sB();}
else if(lE==2)
{return this.sC();}
else
{return this.sD();}
}
this.mK=function()
{var i,j,mE,mF,mG,mD;
var mJ=true;
for(i=0;i<4;i++)
{if(v3[i].mH!=11)mJ=false;}
if(mJ)return 200;
var mI=true;
for(i=1;i<4;i++)
{if(v3[i].mH!=v3[0].mH)
mI=false;}
if(mI)return 100;
var v4=false,v5=false;
for(j=0;j<4;j++)
{
var cot=v3[j];
if(cot.c==mV.vZ)
{if(cot.mH==12){v4=true};
if(cot.mH==13){v5=true};
}}
stuk=(v4&&v5)?20:0;
for(j=0;j<4;j++)
{mE=false;mD=false;
for(i=0;i<4;i++)
{if(v3[i].c==v3[j].c)
{if(v3[i].mH==v3[j].mH+1)
mE=true;
if(v3[i].mH==v3[j].mH-1)
mD=true;}}
if(mD||!mE)continue;
mF=false;
for(i=0;i<4;i++)
{if(v3[i].c==v3[j].c)
{if(v3[i].mH==v3[j].mH+2)
mF=true;}}
if(!mF)continue;
mG=false;
for(i=0;i<4;i++)
{if(v3[i].c==v3[j].c)
{if(v3[i].mH==v3[j].mH+3)
mG=true;
}}
return((mG?50:20)+stuk);}
return stuk;
}
this.s9=function()
{
var pnt=0;
for(var j=0;j<4;j++)
{
pnt+=v3[j].p();
}
return pnt;
}
this.Connect=function(set_adm)
{
mV=set_adm;
vV=set_adm.c.vV;
v3=set_adm.v3;
v6=set_adm.v6;
}
}
function OStack(adm){
this.vV=new Array(32);
this.mW=function()
{var i,j,ii,ki,lT;
for(ii=0;ii<32;ii++)
{ki=Math.floor(24*Math.random());
if(Math.floor(ki/8)==Math.floor(ii/8))ki+=8;
lT=this.vV[ki];
this.vV[ki]=this.vV[ii];
this.vV[ii]=lT;
}
ii=0;
for(ki=0;ki<4;ki++)
{for(i=7;i<=14;i++)
{for(j=ii;j<8;j++)
{if(this.vV[j].mH==i&&this.vV[j].c==ki)
{lT=this.vV[ii];
this.vV[ii++]=this.vV[j];
this.vV[j]=lT;
break;
}}}}
}
this.init=function()
{
for(var kk=0;kk<4;kk++)
{for(var i=0;i<8;i++)
{var ii=kk+Math.floor(i/2);
if(ii>3)ii-=4;
this.vV[i+kk*8]=new o(i+7,ii,this,adm);
}}
var now=new Date();
var j=now.getSeconds()+now.getMinutes();
for(var i=0;i<j;i++)
{
var ki=Math.floor(32*Math.random());
var ii=Math.floor(32*Math.random());
var lT=this.vV[ki];
this.vV[ki]=this.vV[ii];
this.vV[ii]=lT;
}
}
this.reset=function()
{
this.mW();
for(var i=0;i<32;i++)
{
this.vV[i].reset();
}
}
this.init();
}
function OStrategy(adm,level){
var m_adm=adm;
var s_adm=adm.mV;
var b=adm.br;
var vV=adm.mV.c.vV;
var niveau=level;
var nI;
var v2=new Array(8);
var cpu=new OTimer();
this.tooktime=-1;
this.KiesTroef=function(s,modus)
{var i,j,mx=0,n0=[0,0,0,0],retval;
nI=s;
for(i=8*nI;i<8*nI+8;i++)
{var c=vV[i];
if(c.mH==11){n0[c.c]+=20;}
else if(c.mH==9){n0[c.c]+=14;}
else if(c.mH==14){n0[c.c]+=5;}
else{n0[c.c]+=7;}
n0[c.c]+=b.vG(c.mH-7)/28;
}
for(j=0;j<4;j++)
{if(n0[j]>mx)
{mx=n0[j];
retval=j;
}}
if (modus == 'std')
{return retval;}
else if (modus == 'help')
{
return [retval, ''];
}
else
{
var df=99;var jj;
for(j=0;j<4;j++)
{if(j!=retval&&(mx-n0[j]<df))
{df=mx-n0[j];
jj=j}
}
if(df<5){return-1;}
else{return retval;}
}
}
this.sK=function(vS)
{var i,lF=-9999,lG=-1,filter=new Array(8);
if(vS==1)
{for(i=0;i<8;i++)
{filter[i]=b.bK(i);
}}
else
{for(i=0;i<8;i++)
{filter[i]=!vV[i+8*nI].m8;
}}
for(i=0;i<8;i++)
{if(filter[i]&&((lG==-1)||(v2[i]>lF)))
{lG=i;
lF=v2[i];
}}
return lG;
}
this.s7=function()
{var i,aP=0,vR=0;
for(i=0;i<32;i++)
{if(vV[i].c==s_adm.vZ&&vV[i].m8)vR++;}
for(i=8*nI;i<8*nI+8;i++)
{if(vV[i].c==s_adm.vZ&&!vV[i].m8)aP++;}
if(aP+vR==8)
{
return false;
}
else if(aP==0)
{
return false;
}
else if(vR==0)
{
return true;
}
else
{
var kk=new OSetAnalyse(m_adm,nI,env,"aQ");
var aN=(nI+1)%4,aL=0,aO=(nI+3)%4,aM=0;
for(i=0;i<8;i++)
{aL+=kk.perc(s_adm.vZ,aN,i);}
for(i=0;i<8;i++)
{aM+=kk.perc(s_adm.vZ,aO,i);}
return(aL+aM>0);
}
}
this.n8=function()
{
for(var i=8*nI;i<8*nI+8;i++)
{
var im8s=i-8*nI;
var c=vV[i];
if(c.m8)continue;
if(c.c==s_adm.vZ)
{if(c.mH==9||c.mH==14)
{v2[im8s]=(c.s8())?90:-100;}
else if(c.mH<=8||c.mH==13){v2[im8s]=50;}
else if(c.mH==10)
{if(s_adm.vX==1)
{v2[im8s]=25;}
else
{v2[im8s]=(c.s8())?90:-100;
}}
else if(c.mH==11)
{v2[im8s]=100;}
else{v2[im8s]=1;}
if(!this.s7())
{v2[im8s]-=150;}
}
else
{if(c.mH==14)
{v2[im8s]=20;}
else if(c.mH==10||c.mH==12)
{v2[im8s]=((c.s8())?15:5);}
else
{v2[im8s]=((c.s8())?12:8);}
}}}
this.mM=function(s,modus)
{
nI=s;
if(nI==2||niveau>1)
{this.n8();}
else
{for(var i=0;i<8;i++)
{v2[i]=0;
}}
var mxf=this.sK(2);
if (nI == 0 && modus == 'auto')
{
var smxf=v2[mxf];
v2[mxf]=-999;
var f2=this.sK(2);
var smxf2=v2[f2];
if(smxf-smxf2>9)
{return mxf;}
else
{return-1;}
}
else
{return mxf+8*nI;}
}
this.nE=function()
{var i,lB,r;
for(i=8*nI;i<8*nI+8;i++)
{
var im8s=i-8*nI;
var ci=vV[i];
if(b.bK(im8s))
{
s_adm.VirtueleZet(nI,ci,null);
lB=b.sA();
r=b.mK();
s_adm.WisVirtueleZet(nI,null);
if(lB==nI)
{if(ci.c==s_adm.vZ)
{v2[im8s]=r+15;
}else
{v2[im8s]=r+20;
}}
else if((lB%2)==(nI%2))
{if(ci.c==s_adm.vZ)
{v2[im8s]=r+25-ci.p();
}else
{if(ci.mH==10&&!ci.s8())
{v2[im8s]=r+31;}
else
{v2[im8s]=r+30-ci.p();
}}}
else
{if(ci.c==s_adm.vZ)
{v2[im8s]=-r-20-ci.p();
}else
{v2[im8s]=-r-20-ci.p();
}}}}}
this.Kaart23_niv4=function(cnr)
{
cpu.starttimer();
var nrm=1.0;
var kk=new OSetAnalyse(m_adm,nI,env,"nF");
var sll=(nI+1)%4;
var slm=(nI+2)%4;
var sll_bekend=kk.kans_bekennen(sll,s_adm.g1);
var slm_bekend=kk.kans_bekennen(slm,s_adm.g1);
var sll_troef=kk.kans_bekennen(sll,s_adm.vZ);
var slm_troef=kk.kans_bekennen(slm,s_adm.vZ);
var sll_troeft_in=(1.0-sll_bekend)*sll_troef;
var slm_troeft_in=(cnr==2?(1.0-slm_bekend)*slm_troef:0);
if(s_adm.g1==s_adm.vZ){sll_troeft_in=0;slm_troeft_in=0;}
var p1=new Array(8),p2=new Array(8),p3=new Array(8),p13=new Array(8);
var ksll=new Array(8),lB=new Array(8);
var roem=new Array(8);
var wk=new Array(8),szcp=new Array(8);
for(var i=8*nI;i<8*nI+8;i++)
{
var im8s=i-8*nI;
if(b.bK(im8s))
{
var c=vV[i];
s_adm.VirtueleZet(nI,c,kk);
lB[im8s]=b.sA();
if(cnr==2)
{
var rtvlkk=kk.kans_hoger_dubbel(sll,s_adm.g1,sll_bekend,slm_bekend,sll_troef,slm_troef);
ksll[im8s]=rtvlkk[0];
roem[im8s]=rtvlkk[1];
}
else
{
var rtvlkk=kk.kans_hoger(sll,s_adm.g1,sll_bekend,sll_troef);
ksll[im8s]=rtvlkk[0];
roem[im8s]=rtvlkk[1];
}
s_adm.WisVirtueleZet(nI,kk);
if((c.c!=s_adm.g1)&&(c.p()>=10))
{
p1[im8s]=-100;
p3[im8s]=-100;
}
else if(c.c!=s_adm.g1)
{
p1[im8s]=-50-c.h();
p3[im8s]=-50-c.h();
}
else
{if(c.c==s_adm.vZ)
{
p1[im8s]=25-c.p();
p3[im8s]=25-c.p();
}
else
{if(c.mH==10)
{
p1[im8s]=35+(c.s8()?25:0);
p3[im8s]=26;
}
else
{
p1[im8s]=50+c.h();
p3[im8s]=50;
}
}
}
p2[im8s]=-20-c.p();
p13[im8s]=(lB[im8s]==nI?p1[im8s]:p3[im8s]);
wk[im8s]=1.0-ksll[im8s];
v2[im8s]=p13[im8s]*wk[im8s]+p2[im8s]*(nrm-wk[im8s])-roem[im8s];
}}
cpu.stoptimer();
var timetaken=cpu.tooktime;
}
this.nF=function()
{var i,lB;
for(i=8*nI;i<8*nI+8;i++)
{
var im8s=i-8*nI;
if(b.bK(im8s))
{s_adm.v3[nI]=vV[i];
s_adm.v6[nI]=true;
lB=b.sA();
s_adm.v6[nI]=false;
var c=vV[i];
if((c.c!=s_adm.g1)&&(c.p()>=10))
{v2[im8s]=-100;}
else if((lB%2)==(nI%2))
{if(c.c==s_adm.vZ)
{v2[im8s]=25-c.p();
}
else
{if(c.mH==10)
{if(c.s8())
{v2[im8s]=60;
}
else
{v2[im8s]=26;}
}
else
{v2[im8s]=50;}
}
}
else
{v2[im8s]=-20-c.p();
}}}}
this.mN=function(s)
{nI=s;
cpu.starttimer();
var retval;
var i,lI=b.s1(nI);
if(lI[0]==1)
{retval=lI[1];
}
else
{if(nI%2==1&&niveau<3)
{for(i=0;i<8;i++)
{v2[i]=0;
}}
else
{var cnr=(4+nI-s_adm.g3)%4;
if(cnr==3)
{this.nE();}
else if(niveau>3||nI%2==0)
{this.Kaart23_niv4(1+cnr)
}
else
{this.nF();
}}
retval=8*nI+this.sK(1);
}
cpu.stoptimer();
this.tooktime=cpu.tooktime;
return retval;
}
this.reset=function(level)
{
niveau=level;
for(var i=0;i<8;i++){v2[i]=0;}
}
}
function OEnvironment(button_level)
{
var ml=4;
var v9=new Array(3);
var bL,level;
var Cbig_scr,Cgfx,CAmsRot;
var BNiv=button_level;
function f(x){return(document.URL.indexOf(x)>=0);}
this.sG=function()
{
setCookie("kj",v9.join("_"));
setCookie("kj_settings",bL.join("_"));
}
this.sH=function()
{
var l3=getCookie("kj");
if(l3==null)
{l3="Ams_gfx_1";
}
v9=l3.split("_");
var settings_koekkie=getCookie("kj_settings");
if(settings_koekkie==null){settings_koekkie="0_0_1_0_inf_3";}
bL=settings_koekkie.split("_");
}
this.init=function()
{
Cbig_scr=!f("klein");
Cgfx=f("gfx");
CAmsRot=!f("rdam");
this.sH();
v9[0]=mU(CAmsRot);
v9[1]=(Cgfx?"gfx":(Cbig_scr?"txt":"palm"));
Cverbose=parseInt(bL[1]);
Cround=parseInt(bL[2])>0;
Cautom=parseInt(bL[3])>0;
Cstopna=parseInt(bL[4]);
Ctempo=parseInt(bL[5]);
level=parseInt(v9[2]);
if(!isNaN(level))
{
level=Math.min(ml,Math.max(1,level));
}
else
{
level=3;
this.sG();
}
}
this.g2=function(){return Cbig_scr;}
this.gfx=function(){return Cgfx;}
this.vW=function(){return CAmsRot;}
this.aH=function(){return Cverbose;}
this.round=function(){return Cround;}
this.autom=function(){return Cautom;}
this.stopna=function(){return Cstopna;}
this.tempo=function(){return Ctempo;}
this.niveau=function(){return level;}
this.IncNiveau=function(i)
{
var oldlevel=level;
level=Math.min(ml,Math.max(1,level+i));
if(oldlevel!=level)
{
if(BNiv){BNiv.HuidigNiv.value=level;}
v9[2]=level;
this.sG();
}
}
this.init();
}
function OScore(setting_rondaf,adm)
{
var gC;
var sU=setting_rondaf;
var m_adm=adm;
this.add_score=function(w,pnt,roem,slag)
{
if(slag==8){pnt+=10;}
if(w==0||w==2)
{
gC++;
this.g8+=pnt;
this.gA+=roem;
}
else
{
this.g9+=pnt;
this.gB+=roem;
}
}
this.sM=function()
{
var i,l8,
lQ = (this.gA>0)?' + '+this.gA+" roem":"",
lR = (this.gB>0)?' + '+this.gB+" roem":"";
var lS = 'jij+maat: ' + this.g8 + " pnt" + lQ + ";\n" +
'links+rechts: ' + this.g9 + " pnt" + lR + ".\n";
var pit26=(sU?26:262);
var tot16=(sU?16:162);
if(m_adm.mV.g4==0||m_adm.mV.g4==2)
{
if(gC==8)
{
this.g8=pit26;
l8='Een mooie pit !';
}
else
{
if(this.g8+this.gA<=this.g9+this.gB)
{
this.g9=tot16;this.gB+=this.gA;this.gA=0;this.g8=0;
l8="Je bent nat gegaan.";
}
else
{
l8="Je hebt gewonnen:";
if(sU){this.g9=Math.floor((this.g9+4)/10);}
this.g8=tot16-this.g9;
}}
}
else
{
if(gC==0)
{
this.g9=pit26;
l8='Een pit, goed he ?';
}
else
{
if(this.g9+this.gB<=this.g8+this.gA)
{
this.g8=tot16;this.gA+=this.gB;this.gB=0;this.g9=0;
l8='Je hebt me nat gespeeld !!!';
}
else
{
l8="De computer wint.";
if(sU){this.g8=Math.floor((this.g8+4)/10);}
this.g9=tot16-this.g8;
}}}
this.g7+=this.g9+(sU?this.gB/10:this.gB);
this.g6+=this.g8+(sU?this.gA/10:this.gA);
var l4=m_adm.vY+1;
var l5=l4+" potje"+(l4>1?"s":"");
var StandNa=(m_adm.vY+1==m_adm.stopna?"E I N D S T A N D":"stand na "+l5);
return(l8+"\n"+lS+StandNa+
': '
+this.g6+" om "+this.g7);
}
this.reset=function()
{
this.g9=0;
this.gB=0;
this.g8=0;
this.gA=0;
gC=0;
}
this.tussenstand=function()
{
var m5 = '\n\ntussenstand: ' + this.g8 + "-" + this.g9 + "\n";
if(this.gA+this.gB)
{
m5+="roem:"+this.gA+"-"+this.gB+"\n";
}
return m5;
}
this.g6=0;
this.g7=0;
this.reset();
}
function OSetAdmin(adm){
this.vX=-1;
this.vZ=-1;
this.g1=-1;
this.g3=-1;
this.g4=-1;
this.c=new OStack(adm);
this.v3=new Array(4);
this.v6=new Array(4);
this.reset=function(t)
{
this.c.reset();
for(var i=0;i<4;i++){this.v6[i]=false;}
this.vX=1;
this.g1=-1;
this.g4=t;
this.g3=this.g4;
}
this.SetTroef=function(k)
{
this.vZ=k;
for(var i=0;i<32;i++)
{this.c.vV[i].settroef(k);
}
}
this.sL=function(nI,lC)
{
var cnr=this.c.vV[lC];
this.v3[nI]=cnr;
this.v6[nI]=true;
cnr.sL(this.vX,nI,this.g3);
if(this.g3==nI)
{this.g1=cnr.c;}
}
this.VirtueleZet=function(s,c,kk)
{
this.v3[s]=c;
this.v6[s]=true;
if(kk){kk.VirtueleZet(s,c);}
}
this.WisVirtueleZet=function(s,kk)
{
this.v3[s]=null;
this.v6[s]=false;
if(kk){kk.WisVirtueleZet(s);}
}
this.bM=function(lB)
{
this.vX++;
this.g3=lB;
for(var i=0;i<4;i++)
{this.v6[i]=false;}
this.g1=-1;
}
}
function OMatchAdmin(envir){
this.vW=envir.vW();
this.g5=-1;
this.vY=-1;
this.mB=-1;
this.vF;
this.stopna=envir.stopna();
this.autom=envir.autom();
this.sT="",
this.scrn=new OScreenAdmin(envir,this);
this.br=new OBasicRules(envir.vW);
this.score=new OScore(envir.round(),this);
this.mV=new OSetAdmin(this);
this.strat=new OStrategy(this,env.niveau());
this.help=new OHelp(this);
var lB=-1;
var std_timeout=2000/envir.tempo();
this.br.Connect(this.mV);
this.reset=function()
{
if(this.vY==-1){this.g5=Math.floor(4*Math.random());}
this.score.reset();
this.SetTroef(-1);
this.vY++;
this.mV.reset((this.vY+this.g5)%4);
this.scrn.UpdateTroefKleur();
this.scrn.s5();
}
this.KiesTroef=function(i)
{if(this.mB>1)
{this.mB=-1;
this.scrn.sI();
this.SetTroef(i);
this.mB=3;
this.SubAutoKomUit();
}}
this.mZ=function()
{
this.SetTroef(this.strat.KiesTroef(this.mV.g4, 'std'));
}
this.SetTroef=function(k)
{
this.mV.SetTroef(k);
this.scrn.UpdateTroefKleur();
}
this.sL=function(nI,lC)
{
this.mV.sL(nI,lC);
this.scrn.s5();
this.scrn.UpdateTroefKleur();
}
this.NieuwSpel=function()
{
if(this.mB<0)return;
this.scrn.reset();
this.vY=-1;
this.g5=Math.floor(4*Math.random());
this.reset();
this.scrn.msg("Speel volgens de zgn. "+mT(this.vW)+"se regels!");
if(this.mV.g3==0)
{
if(this.SubAutoKiesTroef()<0){return;}
this.SubAutoKomUit();
this.scrn.s5();
}
else
{
this.mZ();
window.setTimeout("lK(0);",std_timeout);
}
}
this.einde_slag=function()
{
var t=
["Jij wint slag!",
"Links wint slag.",
"Je maat wint slag!",
"Rechts wint slag."];
lB=this.br.sA();
var r=this.br.mK();
this.score.add_score(lB,this.br.s9(),r,this.mV.vX);
this.scrn.s5();
this.scrn.sE(0, (r > 0 ? 'Roem = ' + r + '; ' : "") + t[lB]);
return lB;
}
this.bM=function()
{
this.mV.bM(lB);
this.scrn.UpdateTroefKleur();
}
this.einde_potje=function()
{
this.scrn.msg(this.score.sM());
this.scrn.Update_Score_Lijst();
this.help.m6(2);
if(this.vY+1==this.stopna){this.mB=-99;return true;}
this.reset();
return false;
}
this.sO=function(lJ)
{if(this.mV.g3==0)return true;
this.br.s1(0);
if(!this.br.bK(lJ))
{
this.scrn.msg('Ho, ho ! niet vals spelen');
return false;
}
else
{
return true;
}
}
this.mN=function(nI)
{
this.sL(nI,this.strat.mN(nI));
}
this.SpeelDeze=function(lJ)
{
if (lJ > 7) {this.scrn.msg('vreemde kaart opgegooid.');}
if(this.mB==-2)
{
clearTimeout(this.vF);
s3();
if(this.mV.vX==1)return;
}
if((this.mB==1||this.mB==3)&&!this.mV.c.vV[lJ].m8)
{
this.mB=-1;
this.scrn.sI();
if(this.sO(lJ))
{
this.sL(0,lJ);
window.setTimeout("sN(1);",std_timeout);
}
else
{
this.mB=1;
}}
else if(this.mB==2)
{
this.help.HelpFunctie(1);
}}
this.SubAutoKiesTroef=function()
{
var t=-1;
if(this.autom)
{
t = this.strat.KiesTroef(0, 'auto');
}
if(t<0)
{
this.mB=2;
}
else
{
this.SetTroef(t);
this.mB=3;
}
return t;
}
this.SubAutoKomUit=function()
{
if(this.autom)
{
var t = this.strat.mM(0, 'auto');
if(t>=0)
{
this.mB=1;
this.SpeelDeze(t);
}
}
}
this.sN=function(s)
{
var maxn=[3,-1,1,2];
if(this.mV.g3!=1)
{
this.mN(s);
var n=s+1;
if(n<=maxn[this.mV.g3])
{
var timeout=Math.max(1,std_timeout-this.strat.tooktime);
window.setTimeout("sN("+n+");",timeout);
return;
}
}
lB=this.einde_slag();
this.vF=window.setTimeout("s3();",std_timeout);
this.mB=-2;
}
this.s3=function()
{this.mB=-1;
if(this.mV.vX==8)
{
if(this.einde_potje()){return;}
this.scrn.sI();
if(this.mV.g4>0)
{this.mZ();
}
else if(this.SubAutoKiesTroef()<0){return;}
}
else
{
this.scrn.sI();
this.bM();
}
window.setTimeout("lK(0);",std_timeout);
}
this.lK=function(x)
{
var s=this.mV.g3;
var timeout=std_timeout;
if(s>0)
{
var n;
if(x==0)
{
this.sL(s, this.strat.mM(s, 'std'));
n=s+1;
}
else
{
this.mN(x);
timeout=Math.max(1,std_timeout-this.strat.tooktime);
n=x+1;
}
if(n<=3){window.setTimeout("lK("+n+");",timeout);return;}
}
this.scrn.s5();
this.mB=1;
if(this.autom)
{
if(this.mV.vX==8)
{
for(var i=0;i<8;i++)
{if(!this.mV.c.vV[i].m8)
{
window.setTimeout("SpeelDeze("+i+");",std_timeout);
break;
}}}
else if(this.mV.g3>0)
{
var t=this.br.s1(0);
if(t[0]==1)
{
window.setTimeout("SpeelDeze("+t[1]+");",std_timeout);
}
}
else
{
this.SubAutoKomUit()
}}
}
}
function OScreenAdmin(env,adm){
this.g2=env.g2();
this.gfx=env.gfx();
var m_adm=adm;
this.wit=new Image(50,50);
this.vL=new Array(4);
var v8=(this.g2?[12,10,8,11]:[5,4,1,6]);
var sX;
this.msg=function(x)
{
window.alert(x);
}
this.sI=function()
{this.sE(0," ");
if(this.g2){this.sE(1," ");}
}
this.SetValueColorStyle=function(obj,s,k)
{
obj.value=s;
if(sX)
{
obj.style.color=(k==1||k==3)?"red":"black";
obj.style.fontStyle=(k==2||k==3)?"italic":"normal";
}}
this.UpdateTroefKleur=function()
{
var troef=m_adm.mV.vZ,g4=m_adm.mV.g4;
if(this.gfx)
{
for(var j=0;j<4;j++)
{
document.images[j].src=(j==troef||troef==-1)?this.vL[j].src:this.wit.src;
}}
else
{
for(var j=0;j<4;j++)
{
var b=(j==troef||troef==-1);
var value = b ? " " + KRHS[j] + " " : ' - ';
this.SetValueColorStyle(document.KiesTroefKleur.elements[j],value,b?j:-1);
}}
if(this.g2)
{
document.KiesTroefTxt.vld1.value=(troef==-1)?"Kies troef:":"Troef is:";
document.ShowTroefKleur.HuidigeTroefKiezer.value=(g4==-1)?"---":vN[g4];
}}
this.s5=function()
{var i,nK=[6,5,4,7];
if(this.gfx)
{for(i=0;i<8;i++)
{document.images[8+i].src=m_adm.mV.c.vV[i].m8?this.wit.src:m_adm.mV.c.vV[i].nG.src;}
for(i=0;i<4;i++)
{document.images[nK[i]].src=m_adm.mV.v6[i]?m_adm.mV.v3[i].nG.src:this.wit.src;}}
else
{for(i=0;i<8;i++)
{var form_card=document.IndeHand.elements[i];
if(m_adm.mV.c.vV[i].m8)
{
this.SetValueColorStyle(form_card,"***",-1);
}
else
{
var c=m_adm.mV.c.vV[i];
this.SetValueColorStyle(form_card,c.naam,c.c);
}}
for(i=0;i<4;i++)
{var form_card=document.forms[v8[i]].elements[0];
if(m_adm.mV.v6[i])
{
var c=m_adm.mV.v3[i];
this.SetValueColorStyle(form_card,c.naam,c.c);
}
else
{
this.SetValueColorStyle(form_card,"",-1);
}}}
if(this.g2)
{ShowScore.HuidigeScoreU.value=m_adm.score.g8;
ShowScore.HuidigeScoreC.value=m_adm.score.g9;
ShowRoem.HuidigeRoemU.value=m_adm.score.gA;
ShowRoem.HuidigeRoemC.value=m_adm.score.gB;
}}
this.Update_Score_Lijst=function()
{
if(this.g2)
{
var tse=document.TotaleScore.elements;
if(m_adm.vY<tse.length/2)
{
tse[2*m_adm.vY].value=m_adm.score.g6;
tse[2*m_adm.vY+1].value=m_adm.score.g7;
}
else
{
for(i=2;i<tse.length;i++)
{
tse[i-2].value=tse[i].value;
}
tse[tse.length-2].value=m_adm.score.g6;
tse[tse.length-1].value=m_adm.score.g7;
}}}
function sJ()
{
var tse=document.TotaleScore.elements;
tse[0].value=0;
tse[1].value=0;
for(var i=2;i<tse.length;i++)
{
tse[i].value=" ";
}}
this.sE=function(i,t)
{
if(!this.g2&&i==1)
{this.msg(t);}
else
{document.msg.elements[i].value=t;}
}
this.reset=function()
{
this.sI();
if(this.g2){sJ();}
}
this.init=function()
{
this.reset();
if(this.gfx)
{
this.wit.src=document.images[4].src;
this.wit.onLoad="m1(0);";
for(var i=0;i<4;i++)
{
this.vL[i]=new Image(40,40);
this.vL[i].onLoad="m1(0);";
this.vL[i].src="include/"+KRHS[i]+".jpg";
}}
else
{
sX=sY(document.KiesTroefKleur.elements[0]);
}
document.BSpelNiveau.HuidigNiv.value=env.niveau();
}
this.init();
}
var nD=[0,0];
function m1(i,c)
{nD[i]++;
matchadm.scrn.sE(1,37-nD[0]-nD[1]);
}
function sR(j,vU)
{function s0()
{var i,j=0;
if(matchadm.scrn.wit.complete){j++;}
for(i=0;i<4;i++)
{if(matchadm.scrn.vL[i].complete){j++;}}
for(i=0;i<32;i++)
{if(matchadm.mV.c.vV[i].nG.complete){j++;}}
return Math.max(j,nD[0]+nD[1]);}
function m0(j,i)
{window.setTimeout("sR("+j+","+i+");",500);}
function sQ(j)
{for(var i=0;i<(j==2?4:16);i++)
{document.images[i].src=(j==2)?matchadm.scrn.vL[i].src:matchadm.mV.c.vV[16*j+i].nG.src;}}
var vT=true;
var l=s0();
if(vU++==0&&j==0)
{if(vT)sQ(2);
matchadm.scrn.sE(0,'Plaatjes worden geladen, even geduld aub.');}
matchadm.scrn.sE(1,37-l);
if(j<=1)
{if((vU>(2+3*j))&&(l>=(5+16*j)||vU>(10+20*j)))
{if(vT)sQ(j);
m0(j+1,vU);}
else
{m0(j,vU);}}
else if(j==2)
{if((vU>8)&&(l==37||vU>50))
{matchadm.mB=0;
NieuwSpel();}
else
{m0(2,vU);}}}
