this.kid_blacksmith_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Apprentice = null,
		Killer = null,
		Other = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.kid_blacksmith";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Alors que vous vous promenez dans les boutiques de %townname%, vous sentez qu\'on tire sur votre manche. Vous vous retournez pour trouver un enfant, le visage barbouillé de noir, avec deux yeux blancs brillants qui vous fixent. Il demande si vous vous y connaissez en épées. Vous faites un geste vers celle qui se trouve dans votre fourreau. Il tape dans ses mains.%SPEECH_ON%Génial ! Je travaille pour un forgeron là-bas, mais il est parti chercher des lingots de fer. Il m\'a dit de surveiller cette épée spéciale qu\'il fabriquait, mais elle, euh, elle est tombée. Et s\'est cassée. Elle est tombée toute seule et s\'est cassée toute seule. Tu veux bien m\'aider à la remettre en place?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Que quelqu\'un aide le gamin.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null)
				{
					this.Options.push({
						Text = "On dirait que %juggler% veut vous aider.",
						function getResult( _event )
						{
							return "Juggler";
						}

					});
				}

				if (_event.m.Apprentice != null)
				{
					this.Options.push({
						Text = "On dirait que %apprentice% veut vous aider.",
						function getResult( _event )
						{
							return "Apprentice";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "On dirait que %killer% veut vous aider.",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Options.push({
					Text = "Non. Va-t\'en, petit.",
					function getResult( _event )
					{
						return "No";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "No",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Tu dis au gamin d\'aller se faire voir. C\'est probablement un petit pickpocket de toute façon. En parlant de ça, vous vérifiez vos poches pour vous assurer que tout est toujours là.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel soulagement, rien ne semble manquer.",
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
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other% va chercher l\'enfant pour l\'aider. Il l\'aide à replacer la poignée et l\'acier de l\'épée et le petit fait sa magie tout seul, réparant facilement l\'épée en une seule pièce. Vous êtes étonné par son habileté et vous vous demandez à quel point le forgeron lui-même doit être bon si c\'est son apprenti. Une fois le travail terminé, le garçon propose de réparer certaines armes pour la compagnie %companyname%, ce que vous acceptez avec joie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beau travail!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local items = 0;

				foreach( item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && item.getCondition() < item.getConditionMax())
					{
						item.setCondition(item.getConditionMax());
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Votre " + item.getName() + " est réparé"
						});
						items = ++items;

						if (items > 3)
						{
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other% soupire après que tu lui aies demandé d\'aller aider le gamin dans ses tâches. Il s\'avance paresseusement vers l\'enclume du forgeron qui a la forme d\'une molaire et repose sur de fins pilotis en fer. Les marchandises du forgeron sont suspendues à des murs fabriqués à partir de vieilles clôtures en fer, les rebords étant recourbés vers l\'extérieur pour mieux retenir les pièces métalliques. Le gamin tape dans ses mains.%SPEECH_ON%Ne touchez à rien d\'autre, aidez-moi juste avec ça.%SPEECH_OFF%%other% se retourne avec confusion et, au milieu de sa phrase, frappe l\'un des pilotis soutenant l\'enclume. Celle-ci commence à s\'effondrer sur le côté et le gamin se précipite pour la rattraper, ne serait-ce que pour éviter d\'avoir encore plus de problèmes par la suite. Le poids de l\'enclume le plaque contre les pavés, ses membres s\'écartèlent brièvement comme un grillon écrasé sous un pouce. Vous voyez tout cela de loin et sifflez pour que le mercenaire reparte avant qu\'il y ait des problèmes. Il s\'échappe au moment où quelques passants commencent à le remarquer. Il hausse les épaules.%SPEECH_ON%On n\'a rien fait, n\'est-ce pas monsieur ?%SPEECH_OFF%Vous acquiescez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous devriez probablement rester discret pendant un moment.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(1.5, "Accidentally crippled a little boy");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Juggler",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vos suppositions concernant le jongleur qui s\'est porté volontaire pour vous aider se confirment, car vous le voyez bientôt lancer des dagues et des haches en l\'air et épater le public. Voyant la foule se rassembler, il pose un chapeau sur les pavés et continue son numéro. Ils jettent beaucoup d\'argent, et les applaudissements sont impressionnants lorsqu\'il joue son acte final avec cinq masses en même temps. Il se baisse pour ramasser son chapeau et se précipite vers vous.%SPEECH_ON%Une belle journée de travail, n\'est ce pas monsieur?%SPEECH_OFF%En hochant la tête, vous demandez si l\'épée du garçon est cassée. Il retire la sueur de son front.%SPEECH_ON%Qu\'est-ce que vous dites, monsieur? Rejoindre la compagnie? Oui, monsieur, je retourne à la compagnie de suite.%SPEECH_OFF%Vous vous retournez vers la forge pour voir le garçon penché sur l\'enclume, prenant une veste en cuir comme cachette en attendant le retour du forgeron.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un spectacle est un spectacle.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.improveMood(1.0, "Basked in the admiration of a crowd");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}

				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Apprentice",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%apprentice%, le jeune apprenti, est chargé d\'aider le gamin. Il se dirige vers la forge et commence à aider le gamin. Mais il ne se contente pas d\'aider : il reconstitue l\'épée de manière à ce qu\'elle soit plus solide qu\'elle ne l\'était au départ. Le forgeron revient, voit l\'ouvrage, et demande à ce qu\'on lui explique la manière de faire pour réaliser une telle œuvre. %apprentice% rit.%SPEECH_ON%Donnez-moi cette épée et je vous donnerai le secret que mon maître m\'a transmis.%SPEECH_OFF%Vous ne saviez même pas que l\'apprenti savait faire tout cela, mais le garçon n\'est rien si ce n\'est un caillou dans la chaussure. Un échange est fait avec le forgeron et les deux parties partent plus que satisfaites.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je croyais que tu étudiais les paniers et corbeilles?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				_event.m.Apprentice.improveMood(1.0, "Brought his blacksmithing skills to bear");

				if (_event.m.Apprentice.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}

				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous demandez à %killer% d\'aider le gamin. L\'homme s\'exécute avec un sourire qui mets le gamin mal à l\'aise. Il fait quelques pas en arrière et rejette toute aide.%SPEECH_ON%Non monsieur, je pense que je vais bien. Me-merci. Après tout, un homme doit faire ce qu\'il doit faire, non?%SPEECH_OFF%Le tueur sourit, s\'accroupit, pose un pouce sur la joue de l\'enfant et le laisse tranquille.%SPEECH_ON%C\'est vrai, mon garçon. C\'est vrai. Un homme fait ce dont il a besoin.%SPEECH_OFF%Maintenant vous êtes offensé et vous demandez à %killer% d\'aller compter le stock. Il caresse les cheveux du garçon, puis se lève et s\'en va. Le gamin s\'enfuit, mais revient rapidement avec une dague.%SPEECH_ON%Tenez, prenez ça. Gardez ce gars-là loin de moi monsieur s\'il vous plait. C\'est compris? Je ne veux pas avoir affaire à lui et je préférerais me cacher chez le forgeron plutôt que de le revoir. Vous prenez l\'arme, vous le tenez à l\'écart. Marché conclu? Marché conclu, ouais? Prenez-la!%SPEECH_OFF%Vous comprenez que le gamin n\'a jamais négocié de sa vie, ou que c\'est la première fois qu\'il met sa vie en jeu. Dans tous les cas, vous acceptez la dague. Le gamin est soulagé et retourne à la forge ou il travaille, tout en gardant un œil ouvert.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu es un tueur avec le gamin, %killer%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/rondel_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

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

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_other = [];
		local candidates_juggler = [];
		local candidates_apprentice = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(b);
			}
			else if (b.getBackground().getID() == "background.apprentice")
			{
				candidates_apprentice.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		if (candidates_apprentice.len() != 0)
		{
			this.m.Apprentice = candidates_apprentice[this.Math.rand(0, candidates_apprentice.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
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
			"other",
			this.m.Other.getName()
		]);
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getName() : ""
		]);
		_vars.push([
			"apprentice",
			this.m.Apprentice != null ? this.m.Apprentice.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Apprentice = null;
		this.m.Killer = null;
		this.m.Other = null;
		this.m.Town = null;
	}

});

