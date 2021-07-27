this.bad_omen_event <- this.inherit("scripts/events/event", {
	m = {
		Superstitious = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.bad_omen";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_12.png[/img]Les cris parcourent le groupe comme les hurlements du vent. Il n\'y a pas d\'ennemi en vue, donc vous n\'avez aucune idée de la cause de ce problème. Vous marchez dans les rangs pour trouver %superstitious% pratiquement en train de sangloter sur le sol. Il se serre la poitrine d\'une main tandis que l\'autre pointe le ciel, le doigt tremblant de peur. %otherguy% explique que l\'homme a vu une grande flamme de feu traversée par les étoiles. Apparemment, cet idiot pathétique prend ça pour un présage et, bien sûr, ce n\'en est pas un bon. Quoi qu\'il en soit, ça ne vous mènera pas là où vous devez être, alors vous ordonnez aux hommes de marcher. | [img]gfx/ui/events/event_12.png[/img] Les ombres commencent à se replier sur elles-mêmes de manière étrange. Vous vous retournez pour voir le soleil s\'assombrir, un grand cercle noir se déplaçant sur lui. Bientôt, il n\'y a plus de soleil du tout. %superstitious% s\'écrie que la fin des temps est proche, mais avant que ses lamentations puissent avoir une emprise sur le reste de vos hommes, la grande ombre dévoile le soleil une fois de plus et la lumière revient comme si rien ne s\'était passé. Vous dites à cet idiot pathétique de se lever. Vous avez des endroits où aller et les larmes ne vous y mèneront sûrement pas. | [img]gfx/ui/events/event_11.png[/img] %superstitious% est en train de planter son épée dans un terrier quand il pousse un cri. Il bondit hors du terrier et crie qu\'il y a un lapin à deux têtes à l\'intérieur. Apparemment, c\'est un mauvais présage pour les choses à venir. Tout ce qu\'on peut penser, c\'est que deux têtes, ça veut dire plus de viande pour le ragoût. | [img]gfx/ui/events/event_11.png[/img]Vous passez sous un arbre dont les branches sont occupées par un chat noir et un corbeau albinos. %superstitious% pleure à leur vue, disant que c\'est sûrement un signe de la fin des temps. Mais oui, bien sûr. Ces choses ne sont jamais un signe de bonnes choses, n\'est-ce pas ? Yeesh. | [img]gfx/ui/events/event_11.png[/img] Vous tombez sur un crâne de cerf. Au début, cela ne vous dit rien, mais %superstitious% le ramasse avec sérieux. De la poussière s\'échappe du crâne lorsqu\'il le tourne dans tous les sens. Les mains tremblantes, il jette la tête hors de ses mains. Elle s\'entrechoque contre le sol, tombant à l\'endroit où les cornes devraient être. L\'homme effrayé prétend qu\'un devin lui a dit un jour qu\'il rencontrerait un crâne comme celui-ci.\n\nIl y a beaucoup de crânes ici, dites-vous, parce que les choses ont tendance à mourir. Vos paroles ne font rien pour l\'homme qui retourne lentement, et nerveusement, dans le rang. | [img]gfx/ui/events/event_11.png[/img] En marchant, quelques hommes s\'amusent à trouver des formes dans les nuages. Ils plaisantent sur les chiens, les grosses femmes et même sur leur maison, mais l\'amusement prend une tournure sauvage quand %superstitious% voit un nuage de forme étrange qui le met à genoux... Il s\'écrie que ce nuage est de mauvais augure et que le malheur s\'abattra bientôt sur la compagnie. Heureusement, la peur ne gagne pas le reste de la compagnie qui, au lieu de trembler, commence plutôt à se chamailler pour savoir si le nuage est vraiment représentatif de l\'impressionnante dotation de %randombrother%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Ressaisis-toi! | Et je pensais que seuls les enfants avaient des peurs aussi stupides.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Superstitious.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				_event.m.Superstitious.getSkills().add(effect);
				_event.m.Superstitious.worsenMood(1.0, "A vu un mauvais présage");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Superstitious.getName() + " est effrayé"
				});

				if (_event.m.Superstitious.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Superstitious.getMoodState()],
						text = _event.m.Superstitious.getName() + this.Const.MoodStateEvent[_event.m.Superstitious.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2 || !this.World.getTime().IsDaytime)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad")) && !bro.getSkills().hasSkill("effects.afraid"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Superstitious = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Superstitious.getID())
			{
				this.m.OtherGuy = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"superstitious",
			this.m.Superstitious.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Superstitious = null;
		this.m.OtherGuy = null;
	}

});

