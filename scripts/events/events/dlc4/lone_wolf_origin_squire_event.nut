this.lone_wolf_origin_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_squire";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]Le pub est rempli d\'ivrognes qui s\'agitent, applaudissent, chantent, s\'amusent avec les femmes, qu\'il s\'agisse de gueuse, d\'épouse ou de putain. Un homme avec un luth danse et joue, un autre avec des cymbales en métal frappe au-dessus de sa tête tandis qu\'un gros homme entonne des chansons de batailles ou d\'amour, et qu\'il s\'agisse d\'une histoire de victoire ou de défaite, elles provoquent des rondes de bière et plus de joie encore.\n\nVous quittez le pub et entrez dans le bâtiment voisin. Le vent siffle dans une grande église remplie de bancs alors que vous vous tenez sur le seuil de la porte. Un homme qui balaie le sol en pierre lève les yeux pendant un moment puis continue son travail. Un autre homme traverse joyeusement la pièce et vous demande si vous voulez prier. Vous refusez, il pince les lèvres et croise les bras. La foule d\'à côté hurle de plaisir, comme pour se moquer de vous deux, puis il s\'en va. Vous restez un moment de plus, puis vous partez et retournez au centre ville et vous vous accroupissez sur une série de marches. Il semble qu\'il y avait autrefois une statue en haut de ces marches, mais les voyous et les pillards n\'ont fait qu\'une bouchée de cette œuvre artisanale. Vous vous endormez là, au pied où il y avait autrefois une statue.\n\nEn vous réveillant de votre sieste, vous trouvez un jeune homme en bas des marches. Il dit qu\'il sait que vous êtes un chevalier et qu\'il est venu vous offrir ses services en tant qu\'écuyer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "As-tu déjà tué quelqu\'un ?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Qu\'est-ce que tu peux faire ?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Je te prends comme écuyer.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Je travaille seul.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"squire_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez rencontré %name% à " + _event.m.Town.getName() + " où il s\'est porté volontaire pour être votre écuyer. Il n\'avait probablement aucune idée de ce dans quoi il s\'engageait à l\'époque.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/linen_tunic"));
				_event.m.Dude.setTitle("the Squire");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_20.png[/img]{L\'homme secoue la tête pour dire non.%SPEECH_ON%Je n\'ai jamais tué personne, monsieur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que tu peux faire ?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Je te prends comme écuyer.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Je travaille seul.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_20.png[/img]{L\'homme se tient droit.%SPEECH_ON%Je sais comment aiguiser l\'acier et réparer le cuir. Je peux démonter et remonter des armures lourdes et légères, qu\'elles soient simples ou complexes, et je peux le faire rapidement. Si nous avons un cheval...%SPEECH_OFF%Vous l\'interrompez.%SPEECH_ON%Je marche.%SPEECH_OFF%L\'homme continue en bougeant de manière incertaine sur ses pieds.%SPEECH_ON%Très bien. Eh bien, je sais cuisiner. Je peux cuisiner un bon repas, que j\'ai les ingrédients ou pas. Je fais avec. Et. Et. C\'est tout. C\'est à peu près tout. Mais je suis prêt à apprendre !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "As-tu déjà tué quelqu\'un ?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Je te prends comme écuyer.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Je travaille seul.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous demandez à l\'homme son nom. Il déglutit nerveusement.%SPEECH_ON%%squire%, monsieur.%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Bon, d\'accord. Je t\'emmène avec moi.%SPEECH_OFF%Il sourit.%SPEECH_ON%C\'est. C\'est vrai ?%SPEECH_OFF%Vous acquiescez.%SPEECH_ON%Ouais. C\'est vrai.%SPEECH_OFF%%squire% regarde autour de lui.%SPEECH_ON%Bien. Très bien. Et maintenant ?%SPEECH_OFF%Vous vous appuyez sur les marches en pierre.%SPEECH_ON%Suis-moi. Là, je vais faire une autre sieste. Si tu es toujours là à mon réveil, alors tu auras réussi ton premier test. Vaincre l\'ennui.%SPEECH_OFF%Le écuyer sourit jusqu\'aux oreilles. Il est toujours là quand vous vous réveillez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maintenant, j\'ai besoin d\'un verre.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.improveMood(1.0, "Est devenu l\'écuyer d\'un chevalier");
						_event.m.Dude.getFlags().set("IsLoneWolfSquire", true);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous regardez le prétendu écuyer longuement et fermement et vous lui dites non. Il hausse les épaules.%SPEECH_ON%Juste pour que tu saches, tu n\'as pas à être seul dans ce monde. La solitude n\'a pas de visage. Ce n\'est pas un lieu. Ce n\'est pas un être. C\'est une action !%SPEECH_OFF%En crachant, vous vous essuyez le visage et vous riez.%SPEECH_ON%C\'est ce que tu te dis tous les matins ? Va-t\'en.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'ai besoin d\'un verre.",
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
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() > 1)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		this.m.Town = town;
		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

