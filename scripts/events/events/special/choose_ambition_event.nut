this.choose_ambition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.choose_ambition";
		this.m.Title = "Pendant le camp...";
		this.m.HasBigButtons = true;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			Banner = "",
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Text = "[img]gfx/ui/events/event_183.png[/img]{The past few days have been spent mulling over which of Young Anselm\'s beloved Oaths to take on. You feel it in your blood and bones that the right choice is... | Days have come and gone, and in the nights you have mostly sat alone, pondering. But you\'re not always alone. In moments of introspection the Oathtaker Young Anselm arrives, handing you purpose and duty, and this past evening he made it clear to you that the %companyname%\'s next Oath should be... | Between battles internal and out, there remains one eternal war in that of following Young Anselm\'s Oaths. In these trials you must sequester yourself, thinking deeply and alone, until finally, it comes to you! The %companyname%\'s next Oath is most surely... | Sitting alone in thought isn\'t just a physical task. You must clear your mind of all obstruction and distraction, cutting away every element until you are left to darkness in its purest state, where mere glimmers can become divinations, brightly standing amidst all that which is black. And there it is, coming to you in an instant, truth effervescent in its shimmering clarity, held out to you by the glow of Young Anselm\'s hand! The truth of your purpose, and the %companyname%\'s future, it must undertake but one Oath... | Some Oathtakers take to silence, others to songs and ballads. You yourself stand in much quiet, though the noise of the %companyname%\'s doings murmur from the campgrounds. If you are to seek out Young Anselm\'s guidance, then surely he needs to know that you don\'t come alone. As you start to think the Oathtaker is not going to show up, a thought flashes across your mind. The purpose and mission of the %companyname% is now clearer than ever. In an instant, Young Anselm\'s auguries come to your mind and you know that the company shall undertake but one Oath... | The %companyname% would be despondent without purpose. Sensing their needs, you retire yourself to a quiet spot and sit and clear your mind. Young Anselm never allowed himself distractions and you think this will work in your favor just as well. As time begins to pass, a thought nestles within your mind. You trust it to be flighty and will soon go, but instead it only grows and grows, until finally you are made to realize it is a kernel of Young Anselm\'s guidance. And that guidance says only one thing, that the %companyname%\'s Oath should be...}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_58.png[/img]{Une brise fraîche souffle aujourd\'hui, et vous pensez que c\'est le bon moment pour que %companyname% commence quelque chose de nouveau.\n\nVous appelez les hommes à se rassembler... Que leur dites-vous ? | Vous vous sentez bien aujourd\'hui, prêt à mener %companyname% à travers n\'importe quel défi à venir. Vous rassemblez les hommes autour de vous, remettant %randombrother% sur pieds et disant à %randombrother2% de finir de gratter les poils de son cou plus tard. Lorsque leurs marmonnements se sont calmés, vous commencez à vous adresser à eux.\n\nQue dites-vous aux hommes que la compagnie va faire ? | Comme il est de coutume, vous rassemblez les hommes pour expliquer les prochaines actions de la compagnie. %SPEECH_ON%Mes chers frères, %companyname% doit montrer au monde que nous sommes forgés d\'un feu plus chaud que les autres bandes de mercenaires. Plus notre réputation grandira, plus les couronnes afflueront dans nos coffres. Forgeons un chemin vers la grandeur!%SPEECH_OFF%Que dites-vous aux hommes que la compagnie fera ? | Pendant que la compagnie fait une pause, vous décidez de vous adresser aux hommes.%SPEECH_ON%Mes chers frères, je veux que tout le monde sache que %companyname% n\'est pas seulement un groupe de coupes jarrets et un garçon de courses, mais un  groupe de combattants de premier ordre. La nouvelle de nos exploits doit se répandre, afin que les marchands et les nobles nous supplient de prendre leurs contrats.%SPEECH_OFF%Que dites-vous aux hommes concernant les prochains objectifs de la compagnie ? | Assis et plaisantant avec les hommes pendant qu\'ils vérifient leur équipement, affûtent leurs lames et réparent leurs armures, votre esprit s\'égare en réfléchissant à de nouvelles idées pour améliorer la compagnie et sa réputation à travers le pays.\n\nQu\'est ce que vous avez décidez et que dites-vous à vos hommes ? | C\'est à vous, le capitaine, qu\'il incombe de veiller à ce que la compagnie réussisse non seulement sur le champ de bataille, mais aussi dans la gloire et la richesse. C\'est pourquoi vous passez vos soirées à réfléchir à un plan plus vaste pour %companyname% dans votre tente pendant que les hommes parlent et rient autour du feu. Vous n\'allez jamais devenir une légende simplement en pourchassant des brigands et en faisant des petits contrats.\n\nQue proclamez-vous aux hommes que la compagnie va entreprendre ?}";
				}

				local selection = this.World.Ambitions.getSelection();
				this.Options = [];

				foreach( i, s in selection )
				{
					this.Options.push(_event.createOption(s));
				}
			}

		});
	}

	function createOption( _s )
	{
		return {
			Text = _s.getButtonText(),
			Tooltip = _s.getButtonTooltip(),
			Icon = "ui/icons/ambition.png",
			function getResult( _event )
			{
				this.World.Ambitions.setAmbition(_s);
				return 0;
			}

		};
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

