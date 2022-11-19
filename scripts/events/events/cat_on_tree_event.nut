this.cat_on_tree_event <- this.inherit("scripts/events/event", {
	m = {
		Archer = null,
		Ratcatcher = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.cat_on_tree";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous trouvez un garçon et une fille qui regardent en haut d\'un arbre. La fille jette ses mains en l\'air.%SPEECH_ON%D\'accord, reste là jusqu\'à ce que tu meures ! On verra si ça m\'intéresse !%SPEECH_OFF%Le garçon, qui vous a repéré, demande si vous pouvez les aider à faire descendre leur chat de l\'arbre. En levant les yeux, vous voyez un félin allongé sur une branche, se prélassant au soleil.",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, essaye de le faire descendre avec une flèche ?",
						function getResult( _event )
						{
							if (this.Math.rand(1, 100) <= 70)
							{
								return "ArrowGood";
							}
							else
							{
								return "ArrowBad";
							}
						}

					});
				}

				if (_event.m.Ratcatcher != null)
				{
					this.Options.push({
						Text = "%ratcatcherfull% a quelque chose dans sa manche.",
						function getResult( _event )
						{
							return "Ratcatcher";
						}

					});
				}

				this.Options.push({
					Text = "Ce n\'est vraiment pas notre problème.",
					function getResult( _event )
					{
						return "F";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowGood",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% encoche une flèche et tire la langue en visant l\'arbre. La fille et le garçon ne semblent pas apprécier cette idée et se couvrent les yeux avec leurs mains. L\'archer lâche son tir et celui-ci se brise contre la branche du chat, la cassant et envoyant le chat faire la roue le long de l\'arbre. Quand il touche le sol, le garçon et la fille se jettent dessus. Ils le caressent et vous remercient pour vos efforts. La fille serre chaleureusement le chat dans ses bras.%SPEECH_ON%Enfin, nous avons quelque chose à manger !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attendez, quoi?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.getBaseProperties().RangedSkill += 1;
				_event.m.Archer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowBad",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% se prépare, encoche une flèche et vise. Le chat ronronne en fixant la ligne de tir, plutôt sublime dans sa position. Fermant un œil, l\'archer laisse voler la flèche. Il n\'y a pas beaucoup de gémissements à avoir. Le chat dévale l\'arbre et atterrit sur le sol avec un morceau de flèche à moitié sorti de sa tête. La jeune fille s\'accroupit et fixe le morceau de cerveau qui se détache de la pointe de la flèche. Elle lève les yeux vers vous, comme si c\'était vous qui aviez tiré.%SPEECH_ON%C\'était mon ami.%SPEECH_OFF%Vous lui dites que vous êtes désolé et qu\'elle trouvera d\'autres amis. Quant au garçon, il prend le morceau de cerveau et met la carcasse du chat sur son épaule. Il déclare tristement.%SPEECH_ON%Au moins, nous avons quelque chose à manger maintenant.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Repose en paix, chaton.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.worsenMood(1.0, "A accidentellement tiré sur le chat d\'une petite fille");

				if (_event.m.Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Ratcatcher",
			Text = "[img]gfx/ui/events/event_97.png[/img]%ratcatcher% claque des doigts.%SPEECH_ON%J\'ai un plan ! Petits avortons, attendez un moment !%SPEECH_OFF%Le chasseur de rat sort de sa poche un rat dont vous ne soupçonniez pas l\'existence. En faisant couiner ses lèvres comme un chat qui miaule, il brandit le petit rongeur. Le chat l\'a remarqué et a dressé ses oreilles.%SPEECH_ON%Ouais, c\'est ça chaton, descends, c\'est l\'heure du déjeuner.%SPEECH_OFF%Le chasseur de rat porte le rat à ses lèvres et murmure.%SPEECH_ON%Non, c\'est pas vrai.%SPEECH_OFF%Alors que le chat descend, %ratcatcher% tend un peu plus son ami. Le rat commence à gratter et à se déplacer contre ses mains, ne faisant peut-être pas confiance à son maître pour le protéger. Mais au moment où le chat se jette sur son repas, le \"Chasseur de Rats\" range le rat et attrape le chat d\'un seul coup. Les enfants applaudissent et acclament lorsqu\'il leur remet le chat. Même certains hommes sont impressionnés par les réflexes félins du Chasseur de Rats!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Réalisé d\'une main de maître!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Ratcatcher.getBaseProperties().Initiative += 2;
				_event.m.Ratcatcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Ratcatcher.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] d\'Initiative"
				});
				_event.m.Ratcatcher.improveMood(1.0, "Impressed everyone with his swiftness");

				if (_event.m.Ratcatcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
						text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous dîtes sèchement aux enfants qu\'ils feraient mieux d\'avoir un chien et partez sur ces mots.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le chat ne veut pas être votre ami de toute façon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_archer = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidates_archer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_archer.len() == 0 && candidates_ratcatcher.len() == 0)
		{
			return;
		}

		if (candidates_archer.len() != 0)
		{
			this.m.Archer = candidates_archer[this.Math.rand(0, candidates_archer.len() - 1)];
		}

		if (candidates_ratcatcher.len() != 0)
		{
			this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getNameOnly() : ""
		]);
		_vars.push([
			"ratcatcherfull",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer = null;
		this.m.Ratcatcher = null;
		this.m.Town = null;
	}

});

