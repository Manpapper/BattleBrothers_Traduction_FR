this.cultist_origin_vs_uneducated_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Uneducated = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_vs_uneducated";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 13.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Quelques frères viennent vous voir, l\'air plutôt inquiet. Ils disent que %cultist% est assis avec %uneducated% depuis quelques heures maintenant. Lorsque vous leur demandez ce qui les inquiètent, ils vous rappellent que %cultist% a une cicatrice sur le front et parle de choses incroyablement étranges. Ouais. Ce sont les exigences de Davkul, un exemple de leur engagement. Vous ne comprenez pas ce qu\'il y a de mal à cela.\n\nVous allez voir les deux hommes. %uneducated% vous regarde en souriant et dit que le cultist a en fait beaucoup à lui apprendre. C\'est peut-être le cas, mais vous savez que la présence de Davkul n\'a pas besoin d\'être ressentie par tous, et que si elle était imposée au monde, ce serait une mauvaise compréhension du but de Davkul.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Montrez-lui les ténèbres.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Davkul ne veut pas de lui.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous acquiescez et vous vous détournez. Le lendemain matin, %uneducated% est retrouvé avec une blessure fraîche sur le front, le sang de la conversion et le prix que certains doivent payer pour se dévouer à Davkul. Lorsque vous lui demandez comment il va, il ne dit que quelques mots.%SPEECH_ON%Davkul arrive.%SPEECH_OFF%En secouant la tête, vous le corrigez.%SPEECH_ON%Davkul n\'arrive pas. Davkul nous attend tous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul attend.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				local background = this.new("scripts/skills/backgrounds/converted_cultist_background");
				_event.m.Uneducated.getSkills().removeByID(_event.m.Uneducated.getBackground().getID());
				_event.m.Uneducated.getSkills().add(background);
				background.buildDescription();
				background.onSetAppearance();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Uneducated.getName() + " a été converti en Cultiste"
					}
				];
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous séparez les deux hommes, en disant à %uneducated% d\'aller faire de l\'inventaire. Lorsqu\'il part, %cultist% se moque de vous.%SPEECH_ON%Davkul attend. Vous le voyez dans votre sommeil. Vous le voyez dans les nuits. Ses ténèbres arrivent. Aucune lumière ne brûle à jamais.%SPEECH_OFF%L\'homme s\'arrête et regarde fixement votre âme. Et vous le fixez en retour depuis un endroit qui n\'est pas votre corps. Vous ne voyez que le noir infini qui vous entoure et un trait de lumière à travers lequel %cultist% regarde. Lentement, vous flottez vers la lumière et vous vous retrouvez à cligner des yeux et à fixer l\'homme. Il s\'incline.%SPEECH_ON%Mes excuses, capitaine, je ne savais pas que Davkul avait de tels projets.%SPEECH_OFF%En clignant à nouveau des yeux, vous ne pouvez qu\'acquiescer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul nous attend tous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "On lui a refusé la possibilité de convertir " + _event.m.Uneducated.getName());

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];
		local uneducated_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsSpecial") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().isLowborn() && !bro.getSkills().hasSkill("trait.bright") || !bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.dumb") || bro.getSkills().hasSkill("injury.brain_damage"))
			{
				uneducated_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0 || uneducated_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.Uneducated = uneducated_candidates[this.Math.rand(0, uneducated_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len() * 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"uneducated",
			this.m.Uneducated.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Uneducated = null;
	}

});

