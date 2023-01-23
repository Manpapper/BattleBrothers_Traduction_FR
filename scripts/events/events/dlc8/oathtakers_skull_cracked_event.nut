this.oathtakers_skull_cracked_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_skull_cracked";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% fait irruption dans la tente, les mains tremblantes tenant le crâne du jeune Anselme.%SPEECH_ON%Il est cassé!%SPEECH_OFF%Vous vous levez de votre siège et jetez un coup d\'oeil aux restes sacrés du jeune Anselme. Il y a une petite fente à l\'arrière du crâne. Au début, vous pensez que ce n\'est pas trop grave, mais quand vous mettez votre petit doigt dedans et que vous tirez, l\'os se brise. Vous êtes tous les deux surpris et posez le crâne sur la table. Il n\'y a aucun doute que le crâne pourrait se brisé aussi facilement.%SPEECH_ON%Que devons-nous faire? Comment le réparer?%SPEECH_OFF%Vous réfléchissez à la question très attentivement. La dernière fois que cela s\'est produit, l\'os de la mâchoire du jeune Anselme s\'est brisé. Les Oathtakers se sont séparés, un groupe est resté les Oathtakers, et l\'autre a formé les blasphémateurs, les Oathbringers. Vous ne laisserez pas cela se reproduire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Réparez-le.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Vous sortez un morceau de ficelle et l\'enduisez de lierre et de sève. Puis vous soulevez délicatement la fente du crâne et passez votre doigt dessus avec encore plus de sève. %oathtaker% regarde nerveusement. Satisfait, vous insérez ensuite la ficelle le long de la fissure et reposez toutes les parties en mâchant la ficelle et le lierre collant qui l\'accompagne.  Vous prenez du recul et regardez votre travail. %oathtaker% déglutit.%SPEECH_ON%Je... Je pense que personne ne le remarquera.%SPEECH_OFF%En fait, vous pensez qu\'il est préférable qu\'ils découvrent la fissure dans le crâne sans que quelqu\'un ait tenté de la réparer, plutôt que de voir le travail manuel d\'un pseudo restaurateur de crânes qui aurait essayé de passer en douce. Quoi qu\'il en soit, c\'est fait, et l\'honneur du jeune Anselme a été restauré. %oathtaker% essuie la sueur de son front.%SPEECH_ON%Je crois que c\'était une épreuve, capitaine, et que le jeune Anselm nous a permis de la surmonter. Sa force coule en moi, et aucun mot n\'est capable de décrire l\'honneur que je ressens en ce moment.%SPEECH_OFF%Quoi? Le jeune Anselme n\'avait probablement aucune idée de ce qu\'étaient des sèves collantes et des lierres et vu son état actuel, il en sait probablement encore moins maintenant. Mais... vous laissez %oathtaker% à ses interprétations qui ne vous intéresse pas vraiment.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'aurais dû être croque-mort.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local resolveBoost = this.Math.rand(2, 4);
				_event.m.Oathtaker.getBaseProperties().Bravery += resolveBoost;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});

				if (!_event.m.Oathtaker.getSkills().hasSkill("trait.determined"))
				{
					local trait = this.new("scripts/skills/traits/determined_trait");
					_event.m.Oathtaker.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Oathtaker.getName() + " is now Determined"
					});
				}

				_event.m.Oathtaker.improveMood(1.0, "Had his faith in Young Anselm redoubled");

				if (_event.m.Oathtaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Vous faites taire %oathtaker% et lui dites de fermer la tente. Vous prenez le crâne, le posez sur la table et travaillez immédiatement à le réparer. Malheureusement, dès que vos mains font le moindre effort, la fissure s\'élargit et il y a même des fragments qui s\'envolent et se dispersent un peu partout. Vous lâchez le crâne comme s\'il vous avait brûlé. %oathtaker% vous regarde.%SPEECH_ON%Et maintenant? Qu\'est-ce qu\'on fait? Peut-être qu\'on devrait prendre la parti encore intacte et s\'enfuir pour former un nouveau groupe?%SPEECH_OFF%En vous moquant, vous demandez à cet imbécile s\'il vous prend pour un Oathtaker ou un Oathbringer. Il déglutit et confirme la première hypothèse. C\'est bien vrai, et il n\'y a qu\'une seule chose à faire si c\'est le cas: prétendre que c\'est le désir du Jeune Anselme de se fendre le crâne et que c\'est une démonstration de la façon dont la compagnie %companyname% n\'assument pas d\'être de vrais Oathtakers. Il est d\'accord, et vous finissez par montrer au reste des hommes le crâne dans son entièreté.\n\nAu début, ils ont peur en voyant la fissure, mais ils sont bientôt d\'accord avec vous, que l\'influence du Jeune Anselm est en train de diminuer, non pas à cause du Premier Oathtaker lui-même, mais parce que vous tous, les derniers des Oathtakers, ne respectez pas vos serments! Et que vous devez tous faire mieux pour suivre la voie d\'un véritable Oathtaker! Les hommes hurlent et applaudissent leurs convictions retrouvées grâce au jeune Anselm..}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.25, "Convinced he hasn\'t upheld the oaths as well as he should");

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
							});
						}

						if (this.Math.rand(1, 100) <= 20 && !bro.getSkills().hasSkill("trait.deathwish"))
						{
							local trait = this.new("scripts/skills/traits/deathwish_trait");
							bro.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = bro.getName() + " gains Deathwish"
							});
						}
					}

					bro.improveMood(0.75, "Was compelled to redouble his efforts following the oaths");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 40)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

