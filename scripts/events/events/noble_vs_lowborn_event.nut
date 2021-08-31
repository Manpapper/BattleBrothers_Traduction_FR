this.noble_vs_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_vs_lowborn";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] Vous trouvez %nobleman_short% le noble et %lowborn% à l\'air plutôt débraillé en train de se disputer le dernier morceau de nourriture sur une broche. Apparemment, %lowborn% a pris sa fourchette en premier, mais le noble prétend que sa haute stature lui donne droit à la viande.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Réglez ça vous-mêmes.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Dans la compagnie des mercenaires, personne n\'est de basse ou de haute naissance.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Tu connais les règles du pays, donne au noble ce qu\'il veut.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] Alors que les deux hommes vous regardent pour votre avis, vous croisez les bras et haussez les épaules. Ils se retournent lentement l\'un vers l\'autre. Les autres hommes du camp se lèvent et reculent, laissant la place à ce qui va arriver. Le bas-né tire sa dague en premier. C\'est une chose simple avec un manche en bois et des bords dentelés de façon non naturelle. Le noble tire sa lame en retour, brandissant un métal qui se courbe une lame faite par un fin forgeron. Deux serpents dorés s\'enroulent le long du manche pour mordre le pommeau. Celui qui la manie sourit, disant que la racaille devrait apprendre sa place. Le bas-né sourit comme un homme qui n\'a pas l\'habitude de le faire.\n\n Étonnamment, les deux hommes jettent ensuite les dagues dans les souches sur lesquelles ils sont assis et se lèvent, poings levés, pour un combat plus égal qui ne dépend pas de l\'équipement. Dans la bataille qui s\'ensuit, la broche est immédiatement mise de côté et les flammes s\'élèvent, faisant pleuvoir des braises sauvages et la nourriture abattue est maintenant parfumée de cendres et de suie. Voyant leur repas gâché, le reste de la compagnie met finalement fin au combat, séparant les deux hommes. Ils se menacent et se crachent dessus, mais après quelques minutes, tout se calme.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ils deviendront des frères d\'armes bien assez tôt.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				local injury1 = _event.m.Noble.addInjury(this.Const.Injury.Brawl);
				local injury2 = _event.m.Lowborn.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury1.getIcon(),
					text = _event.m.Noble.getName() + " souffre de " + injury1.getNameOnly()
				});
				this.List.push({
					id = 10,
					icon = injury2.getIcon(),
					text = _event.m.Lowborn.getName() + " souffre de " + injury2.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]Le %nobleman% a l\'air effaré. Il soulève lentement sa fourchette de la broche et %lowborn% s\'enfonce immédiatement le dernier morceau de viande dans la bouche. Le noble se lève et se dirige vers vous. Il se redresse devant vous, heurtant sa poitrine contre la vôtre tandis que vous vous regardez fixement. Quelques hommes posent leurs mains sur leurs pommeaux. %SPEECH_ON%{Se ranger du côté des bas-né, hein ? Je m\'en doutais, puisque tu es toi-même de basse naissance. Ne t\'attends pas à devenir l\'un des nôtres. Tu es un mercenaire à vie. Souviens-toi de ça. | Tu espères avoir un bout de terrain quand tout ça sera terminé, hein ? J\'espère que oui, parce qu\'alors je viendrai frapper et te montrer comment les nobles se traitent vraiment les uns les autres.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hors de ma vue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Noble.worsenMood(2.0, "A été humilié devant la compagnie");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]L\'homme noble sourit en repoussant la fourchette de l\'homme de basse naissance. Le noble prend la nourriture pour lui tandis que le bas-né se lève et fonce vers vous. Alors qu\'il s\'approche, certains hommes semblent prêts à dégainer leur épée, mais vous tendez une main pour les calmer.%SPEECH_ON% Je pensais que tu étais l\'un des nôtres, mais je suppose que non. Je suppose que tu penses qu\'un jour tu seras l\'un d\'entre eux, hein ? Continue de rêver. Comme cet homme me disait, "\Connais ta place\".%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hors de ma vue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
				_event.m.Lowborn.worsenMood(2.0, "A été humilié devant la compagnie");

				if (_event.m.Lowborn.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Lowborn.getMoodState()],
						text = _event.m.Lowborn.getName() + this.Const.MoodStateEvent[_event.m.Lowborn.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 7 && bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() == 0)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.hesitant") && bro.getBackground().isLowborn() && bro.getBackground().getID() != "background.slave")
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = noble_candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nobleman",
			this.m.Noble.getName()
		]);
		_vars.push([
			"nobleman_short",
			this.m.Noble.getNameOnly()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
		_vars.push([
			"lowborn_short",
			this.m.Lowborn.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});

