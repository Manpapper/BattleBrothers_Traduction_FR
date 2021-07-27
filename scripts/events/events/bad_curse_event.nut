this.bad_curse_event <- this.inherit("scripts/events/event", {
	m = {
		Cursed = null,
		Monk = null,
		Sorcerer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.bad_curse";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%superstitious% entre dans votre tente, chapeau à la main. Il fait tourner le bord de son chapeau dans ses doigts comme s\'il y arrachait des plumes. Bien que vous n\'ayez pas dit un mot, l\'homme hoche furieusement la tête et ses yeux jettent un regard autour de lui comme s\'il cherchait les mots à dire.\n\nVous posez votre plume et demandez quel est le problème. Se léchant les lèvres, il hoche à nouveau la tête et commence à expliquer sa situation difficile. Les mots viennent vite, mais l\'essentiel semble être qu\'une sorcière locale a jeté un sort à l\'homme pour qu\'il soit incapable de rapport sexuels, en quelque sorte....\n\nVous secouez la tête et demandez ce que veut la sorcière et %superstitious% répond %paiement% couronnes, de peur que la malédiction soit sur lui pour la vie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "S\'il le faut... va t\'en occuper. Voici les couronnes.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ça n\'arrivera pas.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Ayez %monk% le moine jeter un coup d\'oeil à la place.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Sorcerer != null)
				{
					this.Options.push({
						Text = "Ayez %sorcerer% le sorcier jeter un coup d\'oeil à la place.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Cursed.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Le pouce et le doigt vous vous fermez les yeux, vous vous demandez si c\'était vraiment la vie pour vous. Tuer, c\'est facile, mais ça ? Peu importe. Vous levez les mains et vous vous levez de votre chaise pour récupérer votre sacoche de couronnes. L\'homme superstitieux se dresse sur la pointe des pieds.%SPEECH_ON%S\'il vous plaît comptez ! Il ne doit pas manquer une couronne !%SPEECH_OFF%Vous déposez à contrecœur la sacoche sur la table et commencez à compter. Une fois que le compte est bon, vous le mélangez dans un sac et le lancez à %superstitious%. Il s\'incline, vous remerciant ainsi que votre pitié. Vous faites signe à l\'homme de partir pour le faire sortir rapidement de votre tente.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les choses que j\'endure...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				_event.m.Cursed.improveMood(3.0, "A été guéri d\'une malédiction");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
				});
				this.World.Assets.addMoney(-400);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous avez dépensé [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 400 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous ne faites qu\'assombrir la piètre figure de %superstitious% avec cette mauvaise nouvelle : vous ne payerez rien à aucune sorcière.%SPEECH_ON%Quelques mots farfelus prononcés par une femme étrange dans les bois ne constituent pas une base pour des affaires. Ce que vous avez entendu est une tentative de larcin pour vous atteindre, mercenaire. Vous ne pouvez écouté ce genre de larcin, dans cegenre de cas ils ne veulent qu\'une chose vos Couronnes.%SPEECH_OFF%Aucun de ces mots n\'aide %superstitious% car il sort rapidement de la tente, peut-être à la poursuite d\'un autre mercenaire qui lui accordera un prêt.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Certaines personnes ne peuvent pas être aidées.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				_event.m.Cursed.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Cursed.getName() + " est effrayé"
					}
				];
				_event.m.Cursed.worsenMood(2.0, "Vous m\'avez déçu");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous vous demandez si %monk% peut vous aider, vous allez chercher le saint homme..\n\nIl dit qu\'il peut en effet donner un coup de main car les anciens dieux sont toujours en guerre contre la sorcellerie et autres sortilèges. Avant qu\'il ne se lance dans un long monologue sur ce vieux dieu ou ou un autre, vous vous écartez et vous lui envoyez %superstitious%. Pendant quelques minutes, la paix et la tranquillité règnent dans votre tente. Mais vous savez que ça ne peut pas durer, car vous êtes comme un homme au bord du gouffre, attendant un coup de vent pour vous faire tomber.\n\n Cependant, %superstitious% ne revient pas. Après quelques minutes de plus, vous vous rendez compte qu\'il n\'a toujours pas fait d\'entrée fracassante. En fait, son absence totale vous met à cran, comme si le silence lui-même pouvait vous harceler. Vous quittez la tente pour trouver le moine et le soi-disant homme maudit en pleine discussion religieuse. En souriant, vous retournez à votre tente. S\'il y a une chose pour laquelle les hommes saints sont les meilleurs, c\'est pour maintenir un sentiment de tranquillité.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela devrait mettre un terme à cela.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				this.Characters.push(_event.m.Monk.getImagePath());

				if (!_event.m.Cursed.getFlags().has("resolve_via_curse"))
				{
					_event.m.Cursed.getFlags().add("resolve_via_curse");
					_event.m.Cursed.getBaseProperties().Bravery += 1;
					_event.m.Cursed.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Cursed.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
					});
				}

				if (!_event.m.Monk.getFlags().has("resolve_via_curse"))
				{
					_event.m.Monk.getFlags().add("resolve_via_curse");
					_event.m.Monk.getBaseProperties().Bravery += 1;
					_event.m.Monk.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous claquez des doigts, vous souvenant soudain de %sorcerer%, le soi-disant sorcier. Ne voulant pas passer une minute de plus à faire partie de cette étrange affaire, vous renvoyez %superstitieux% au sorcier. Il s\'empresse de partir, mais revient malheureusement quelques minutes plus tard, expliquant que %sorcerer% l\'a libéré de sa malédiction.%SPEECH_ON%Tout ce que j\'ai eu à faire c\'était...%SPEECH_OFF%Vous levez la main, pour arrêter l\'histoire de l\'homme avant même qu\'elle commence. Il vous demande si vous voulez entendre la suite et vous lui répondez par un non ferme.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela devrait mettre un terme à cela.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cursed.getImagePath());
				this.Characters.push(_event.m.Sorcerer.getImagePath());
				_event.m.Cursed.improveMood(3.0, "A été guéri d\'une malédiction");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cursed.getMoodState()],
					text = _event.m.Cursed.getName() + this.Const.MoodStateEvent[_event.m.Cursed.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		local candidates_cursed = [];
		local candidates_monk = [];
		local candidates_sorcerer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getSkills().hasSkill("trait.superstitious"))
			{
				candidates_cursed.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.sorcerer")
			{
				candidates_sorcerer.push(bro);
			}
		}

		if (candidates_cursed.len() == 0)
		{
			return;
		}

		this.m.Cursed = candidates_cursed[this.Math.rand(0, candidates_cursed.len() - 1)];

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		if (candidates_sorcerer.len() != 0)
		{
			this.m.Sorcerer = candidates_sorcerer[this.Math.rand(0, candidates_sorcerer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = candidates_cursed.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"superstitious",
			this.m.Cursed.getNameOnly()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"sorcerer",
			this.m.Sorcerer != null ? this.m.Sorcerer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"payment",
			"400"
		]);
	}

	function onClear()
	{
		this.m.Cursed = null;
		this.m.Monk = null;
		this.m.Sorcerer = null;
		this.m.Town = null;
	}

});

