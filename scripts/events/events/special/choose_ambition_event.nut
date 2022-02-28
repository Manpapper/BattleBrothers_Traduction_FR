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
			Text = "[img]gfx/ui/events/event_58.png[/img]{Une brise fraîche souffle aujourd\'hui, et vous pensez que c\'est le bon moment pour que %companyname% commence quelque chose de nouveau.\n\nVous appelez les hommes à se rassembler... Que leur dites-vous ? | Vous vous sentez bien aujourd\'hui, prêt à mener %companyname% à travers n\'importe quel défi à venir. Vous rassemblez les hommes autour de vous, remettant %randombrother% sur pieds et disant à %randombrother2% de finir de gratter les poils de son cou plus tard. Lorsque leurs marmonnements se sont calmés, vous commencez à vous adresser à eux.\n\nQue dites-vous aux hommes que la compagnie va faire ? | Comme il est de coutume, vous rassemblez les hommes pour expliquer les prochaines actions de la compagnie. %SPEECH_ON%Mes chers frères, %companyname% doit montrer au monde que nous sommes forgés d\'un feu plus chaud que les autres bandes de mercenaires. Plus notre réputation grandira, plus les couronnes afflueront dans nos coffres. Forgeons un chemin vers la grandeur!%SPEECH_OFF%Que dites-vous aux hommes que la compagnie fera ? | Pendant que la compagnie fait une pause, vous décidez de vous adresser aux hommes.%SPEECH_ON%Mes chers frères, je veux que tout le monde sache que %companyname% n\'est pas seulement un groupe de coupes jarrets et un garçon de courses, mais un  groupe de combattants de premier ordre. La nouvelle de nos exploits doit se répandre, afin que les marchands et les nobles nous supplient de prendre leurs contrats.%SPEECH_OFF%Que dites-vous aux hommes concernant les prochains objectifs de la compagnie ? | Assis et plaisantant avec les hommes pendant qu\'ils vérifient leur équipement, affûtent leurs lames et réparent leurs armures, votre esprit s\'égare en réfléchissant à de nouvelles idées pour améliorer la compagnie et sa réputation à travers le pays.\n\nQu\'est ce que vous avez décidez et que dites-vous à vos hommes ? | C\'est à vous, le capitaine, qu\'il incombe de veiller à ce que la compagnie réussisse non seulement sur le champ de bataille, mais aussi dans la gloire et la richesse. C\'est pourquoi vous passez vos soirées à réfléchir à un plan plus vaste pour %companyname% dans votre tente pendant que les hommes parlent et rient autour du feu. Vous n\'allez jamais devenir une légende simplement en pourchassant des brigands et en faisant des petits contrats.\n\nQue proclamez-vous aux hommes que la compagnie va entreprendre ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			Banner = "",
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
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

