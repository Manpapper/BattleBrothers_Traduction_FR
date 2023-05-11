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
					this.Text = "[img]gfx/ui/events/event_183.png[/img]{Ces derniers jours, vous avez réfléchi au serment du jeune Anselm que vous alliez prononcer. Vous sentez dans votre sang et dans vos os que le bon choix est... | Les jours se succèdent et les nuits, vous restez le plus souvent seul à réfléchir. Mais vous n'êtes pas toujours seul. Dans les moments d'introspection, le jeune Anselm, le prêteur de serments, arrive, vous donnant un but et un devoir, et le soir dernier, il vous a fait comprendre que le prochain serment de la compagnie %companyname% devait être... | Entre les batailles internes et externes, il reste une guerre éternelle, celle du respect des serments du jeune Anselm. Dans ces épreuves, vous devez vous isoler, réfléchir profondément et seul, jusqu'à ce qu'enfin, cela vienne à vous ! Le prochain serment de la compagnie %companyname% sera très certainement... | S'asseoir seul dans ses pensées n'est pas seulement une tâche physique. Vous devez débarrasser votre esprit de toute obstruction et de toute distraction, éliminer tout élément jusqu'à ce qu'il ne vous reste plus que l'obscurité dans son état le plus pur, où de simples lueurs peuvent devenir des divinations, se dressant brillamment au milieu de tout ce qui est noir. Et la voilà, elle vient à vous en un instant, la vérité effervescente dans sa clarté chatoyante, tendue vers vous par l'éclat de la main du jeune Anselm ! La vérité de votre objectif et de l'avenir de la compagnie %companyname%, elle ne doit prêter qu'un seul serment... | Certains prêteurs de serments préfèrent le silence, d'autres les chants et les ballades. Vous êtes vous-même dans un grand silence, bien que le bruit des activités de la compagnie %companyname% murmure depuis les campements. Si vous voulez demander conseil au jeune Anselm, il faut qu'il sache que vous n'êtes pas venu seul. Alors que vous commencez à penser que le prêteur de serments ne viendra pas, une idée vous traverse l'esprit. Le but et la mission de la compagnie %companyname% sera maintenant plus clairs que jamais. En un instant, les augures du jeune Anselm vous reviennent à l'esprit et vous savez que la compagnie ne prêtera qu'un seul serment... | La compagnie %companyname% serait découragé si elle n'avait pas de but. Pressentant leurs besoins, vous vous retirez dans un endroit tranquille pour vous asseoir et faire le vide dans votre esprit. Le jeune Anselm ne s'est jamais permis de se distraire et vous pensez qu'il en sera de même pour vous. Alors que le temps commence à passer, une pensée s'installe dans votre esprit. Vous pensez qu'il s'agit d'une idée légère et qu'elle disparaîtra rapidement, mais au lieu de cela, elle ne cesse de grandir, jusqu'à ce que vous réalisiez qu'il s'agit du coeur des conseils du jeune Anselm. Et ces conseils ne disent qu'une chose : le serment de la compagnie %companyname% devrait être...}";
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

