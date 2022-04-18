this.fire_juggler_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Juggler = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.fire_juggler";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 160.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Un jongleur de feu a les yeux de tous sur la place de %townname%. Il a un jeu de torches avec des poignées en bronze. Son numéro se déroule plutôt bien, mais il fait tomber une torche à un moment donné, ce qui soulève quelques huées en retour. Le numéro suivant consiste à placer une planche au-dessus d\'un baril de pétrole ouvert et à jongler avec les torches, les bras le long du corps, mais avec cinq torches au lieu de trois. Mais la foule continue à l\'acclamer et à le railler, sans doute en reniflant et en soufflant comme un loup qui presse un cerf sur le bord de la falaise, et le jongleur, les yeux écarquillés, cherche une forme d\'échappatoire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons comment il s\'y prend.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				},
				{
					Text = "Nous devons l\'aider !",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "%juggler%, tu sais jongler, tu ne peux pas l\'aider ?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous soupirez et vous vous avancez, criant fort au jongleur, faisant semblant d\'être son manager, lui disant qu\'il ne doit pas encore dévoiler le grand spectacle. La foule se calme, confuse, puis se moque de vous. Un tirage de la moitié de votre épée les calme, et d\'autres murmurent des mots de mercenaires, manifestant une série de sifflements et de huées. Mais ils finissent par se disperser. Le jongleur de feu descend de sa pièce de théâtre et vous remercie à plusieurs reprises.%SPEECH_ON%Je ne suis pas prêt, je ne suis pas prêt, et cela vous le voyez avec un œil d\'aigle, gentil étranger ! Tenez, mes gains du jour, prenez-les tous, car rien de tout cela n\'aurait signifié une couronne pour moi si j\'avais dû monter là-haut et mourir !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez soin de vous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous croisez les bras et attendez le spectacle. Le jongleur de feu monte sur le tonneau. Il abaisse une torche et l\'un des villageois l\'allume, mais lorsque le bouffon remonte la torche, le villageois fait mine de jeter son propre feu dans la cuve d\'huile. Le jongleur s\'éloigne momentanément et la foule rit tandis que le bouffon, déconcerté, s\'esclaffe. Mais le bouffon réussit son numéro. Les cinq torches tournent et virevoltent et, à quelques reprises, une braise s\'échappe et touche le bord du baril d\'huile, mais il maîtrise la situation et les huées de la foule se transforment en acclamations et, lorsqu\'il a terminé, les gens applaudissent puis se dispersent lentement, passant à la prochaine forme de divertissement. Un homme dépose quelques couronnes dans les mains du jongleur et c\'est tout.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
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
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "A été diverti par un jongleur de feu");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous croisez les bras et attendez le spectacle. Le jongleur de feu monte sur le tonneau. Il abaisse une torche et l\'un des villageois l\'allume, mais lorsque le bouffon remonte la torche, le villageois fait mine de jeter son propre feu dans la cuve d\'huile. Le jongleur s\'éloigne momentanément et la foule rit tandis que le bouffon, déconcerté, s\'esclaffe. Quand le bouffon commence son numéro, il commence par s\'immoler par le feu. Littéralement, la première torche lui glisse entre les mains et va droit dans la cuve qui lance un panache de flammes dont on ne distingue pas l\'homme du feu, à part les cris d\'enfer. Il se précipite hors de la scène et la foule ne fait que se retourner pour le montrer du doigt et rire. Quand il est mort, ses couronnes sont prises par l\'un des résidents. Ils lèvent l\'or vers le ciel, mentionnent en passant le Doreur, puis jettent les couronnes dans les flammes. Son corps est laissé aux chiens. Une fois que tout est dit et fait, vous fouillez dans les cendres et trouvez une plaque d\'or fondu. Pas vraiment de grande valeur, mais ça doit bien valoir quelque chose et vous la prenez quand personne - pas même les chiens - ne regarde.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "L\'or est de l\'or.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 40);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%juggler%, l\'ancien jongleur de la compagnie, s\'avance. Il s\'approche de la scène qui est suspendue de façon précaire au-dessus de la cuve d\'huile. Les deux échangent des mots, puis %juggler% est le seul à rester debout. Il exécute le numéro - qu\'il n\'a ni pratiqué ni vu auparavant - et le termine sans problème. La foule est silencieuse, cependant. Ils se contentent de regarder, ne jetant qu\'un coup d\'œil occasionnel à vous et à la compagnie. Lorsque %juggler% termine, il ouvre grand les bras, mais il n\'y a pas d\'applaudissements.%SPEECH_ON%Le doreur crache sur toi mercenaires, intrus, tu ne danses pour personne. Et toi, jongleur de feu, qu\'as-tu à dire pour ta défense ? %SPEECH_OFF%%nom du village%% le jongleur de feu réfléchit, puis se tourne vers toi. %SPEECH_ON% Je dis que je suis fatigué de ces bêtises, et si le Doreur nous méprise tant, alors je vais le faire me mépriser entre les rangs de cette compagnie. Qu\'en dites-vous, capitaine des Mercenaires, vous me prenez à bord ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue au %companyname%",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Ce n\'est pas un endroit pour toi.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"juggler_southern_background"
				]);
				_event.m.Dude.setTitle("the Fire Juggler");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% dans les rues de " + _event.m.Town.getName() + ", prêt à faire une démonstration enflammée de jonglage de feu qui aurait pu lui coûter la vie. Heureusement, " + _event.m.Juggler.getName() + " a sauté sur l\'occasion pour exécuter le numéro avec lui, lui sauvant peut-être la vie. Par la suite, %name% en a eu assez de son métier et s\'est porté volontaire pour rejoindre votre compagnie.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/fearless_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.improveMood(1.0, "Got saved from a possible flaming death by a fellow juggler");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Tu hoches la tête. %SPEECH_ON%Cracheur de feu, mercenaire, peu importe. Vous êtes avec la %companyname%.%SPEECH_OFF%La foule siffle à nouveau, mais vous leur dites d\'aller se faire foutre, en assaisonnant la menace d\'un éclair de votre épée juste au cas où ils auraient des problèmes de compréhension. %firejuggler%, le jongleur de feu, vous remercie abondamment et rejoint rapidement vos rangs où la compagnie l\'accueille avec autant de réticence que n\'importe quelle nouvelle recrue. Quant aux gens de %townname%, ils se lassent rapidement du drame et poursuivent leur vie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le spectacle est terminé, les amis.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Faire une grande démonstration de jonglage de feu");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Compétence au corps à corps"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous secouez la tête. Le jongleur de feu baisse la sienne.%SPEECH_ON%Oh. Je croyais qu\'il y avait un truc entre nous.%SPEECH_OFF%Prétrisant vos lèvres, vous secouez à nouveau la tête.%SPEECH_ON%Non...il n\'y a pas de truc entre nous. Je ne veux simplement pas de toi dans ma compagnie, sans rancune. Continuez, euh, à vous entraîner. Tu sais, avec le feu et les bâtons, tu y arriveras un jour, j\'en suis sûr. Le jongleur de feu hoche la tête. Bien sûr. Et bien que vous m\'ayez rejeté, je crois que le Doreur nous a placé tous les deux exactement là où nous devions être, et que son intention n\'était pas que nos chemins se croisent inutilement. Je ne manquerai pas de parler en bien de votre compagnie où que j\'aille !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que la voie du doreur pour nous deux soit aussi bonne que tu l\'espères.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
				local meleeSkill = this.Math.rand(1, 3);
				_event.m.Juggler.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Juggler.getSkills().update();
				_event.m.Juggler.improveMood(1.0, "Put on a great display of fire juggling");
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Compétence au corps à corps"
				});

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_juggler = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(bro);
			}
		}

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getNameOnly() : ""
		]);
		_vars.push([
			"firejuggler",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Juggler = null;
		this.m.Dude = null;
	}

});

