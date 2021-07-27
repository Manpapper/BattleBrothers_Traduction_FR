this.beat_up_old_man_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null
	},
	function create()
	{
		this.m.ID = "event.beat_up_old_man";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 60 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Vous croisez un vieil homme qui boitille le long de la route. Il s\'installe contre sa canne et attend vous approchiez. Ses yeux sont gris, mais il penche la tête comme s\'il voulait vous voir avec ses oreilles.%SPEECH_ON%Des cliquetis d\'armures. Des pas lourds. Des respirations régulières. Plus de guerriers pour une terre de guerre.%SPEECH_OFF%L\'homme se redresse comme s\'il voulait dire : \"J\'ai raison ?\". Vous lui dites que vous n\'êtes pas là pour lui faire du mal.%SPEECH_ON%Donc oui, j\'ai raison, comme d\'habitude. Ça ne devrait pas être trop difficile de me chasser. Mon ouïe est en train de partir et je suppose qu\'une fois qu\'elle sera partie, je partirais aussi.%SPEECH_OFF%Il fait une pause et tourne la tête.%SPEECH_ON%Vous avez dit quelque chose?%SPEECH_OFF%Vous remarquez que l\'homme a une belle bague à l\'un de ses doigts squelettiques. %aggro_bro% s\'approche de vous.%SPEECH_ON%On pourrait prendre ça... vous savez, comme on prend une tarte à un bébé. Un bébé vraiment aveugle, et plus impuissant que la normale.%SPEECH_OFF% | Un vieil homme avec une canne se repose contre un mur de pierre. Sa main caresse les pierres avec un contact familier. Il vous regarde fixement, une bague ornée de bijoux brille sur l\'un de ses doigts squelettiques.%SPEECH_ON%Bonsoir, messieurs. Quelle belle journée, n\'est-ce pas?%SPEECH_OFF%En le regardant bien, vous réalisez qu\'il est aveugle. | Vous arrivez devant un vieil homme debout au milieu de la route, son corps appuyé sur une canne. Il regarde fixement un panneau de signalisation. Il secoue la tête.%SPEECH_ON%Je sais qu\'il y a un panneau ici. Je crois que %randomtown% est par là, si je me souviens bien.%SPEECH_OFF%Il se tourne vers vous en souriant. Ses yeux sont blancs, aveuglés par la vieillesse. Une très belle bague, surement très chère, brille sur l\'un de ses doigts squelettiques.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Voyagez prudemment, vieil homme.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Cette bague. Donnez-la-moi.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Vous vous approchez de l\'homme. Sa tête s\'incline.%SPEECH_ON%C\'est un rythme accéléré, étranger, mais je n\'entends pas le son d\'une épée, au contraire...%SPEECH_OFF%Avec une poussée soudaine, vous faites tomber l\'homme au sol. Il s\'accroche à son bâton de marche, dont l\'extrémité est pointée vers le haut, comme si vous pouviez vous empaler sur sa pointe arrondie. Vous dégagez sa main d\'un coup de pied et vous marchez sur son poignet, en vous baissant pour prendre l\'anneau.%SPEECH_ON%Enfonce de l\'acier dans mon coeur tant que tu y es, salaud!%SPEECH_OFF%Vous lâchez l\'homme et lui rendez son bâton, vous l\'aidez même à se relever.%SPEECH_ON%Sans rancune, vieil homme.%SPEECH_OFF% | Vous mettez l\'homme à terre. Il grogne comme si vous veniez de frapper un sanglier malade. En se retournant et en se tenant le ventre, il demande pourquoi, mais vous ne faites que lui donner un nouveau coup de pied pour le mettre sur le dos. De là, vous lui volez facilement l\'anneau et vous partez. | L\'homme fait claquer ses lèvres de vieil homme, ce bruit dégoûtant et crépitant de bouche sèche. En retour, vous vous reculez et lui donnez un coup de poing en plein dans l\'estomac. Ne l\'ayant pas vu venir, le vieillard se prend le coup dans toute sa puissance, expulsant l\'air de ses poumons et tombant à la renverse. Alors qu\'il suffoque, vous lui enlevez l\'anneau et partez. | Le vieil homme se lève et s\'appuie sur sa canne. Il lève la tête.%SPEECH_ON%Hmm, le silence. Le son de la mauvaise intention entre étrangers. Je me tiens dans l\'obscurité, et toi dans la lumière, mais où allons-nous bientôt être?%SPEECH_OFF%Vous donnez un coup de pied dans la canne de l\'homme et il bascule dans un amas maladroit, sa structure squelettique s\'effondrant comme une hutte branlante. Il se retourne et fait preuve de sagacité devant une telle violance. Vous lui donnez un coup de pied dans la poitrine et lui dites de se taire. La bague se détache facilement de son doigt et vous partez. | YVous faites craquer vos articulations. Le vieil homme se recule.%SPEECH_ON%La violence n\'est sûrement pas la solution ? Ce monde n\'a pas besoin de plus de violence.%SPEECH_OFF%D\'un coup de poing rapide, vous le mettez à terre et il s\'écroule par terre. En prenant l\'anneau, et vous répondez.%SPEECH_ON%Je me fous de ce dont ce monde a besoin ou pas. Je suis mon propre monde et vous le vôtre. Leurs chemins se sont juste croisés, c\'est tout. Et devine quoi, vieil homme ? Mon monde est plus grand.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ainsi va la vie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous gagnez " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isOffendedByViolence() && !bro.getBackground().isNoble() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
	}

});

