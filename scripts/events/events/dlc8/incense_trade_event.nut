this.incense_trade_event <- this.inherit("scripts/events/event", {
	m = {
		Dancer = null
	},
	function create()
	{
		this.m.ID = "event.incense_trade";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Alors que vous déblayez un chemin à travers les étendues enneigées, une étrange silhouette s\'avance sur la route. Vous pouvez voir des cordes attachées à ses épaules. Au-dessus d\'elle, des cerfs-volants noirs qui tournent et tourbillonnent comme si la silhouette était une marionnette. Son visage même représente la définition de la folie, ricanant d\'une blague à laquelle il a pensé il y a des années et dont il n\'a jamais cessé de rire. Son teint sombre est inhabituel dans le nord et quand il parle, il connaît votre langue.%SPEECH_ON%Vous avez des étrangetés sur vous, des étrangetés qui sentent bon en plus. Mais qu\'est-ce que c\'est, qu\'est-ce que c\'est? Ce n\'est pas de la viande. Ce n\'est pas de la viande humaine tendre. Ce n\'est pas de la viande d\'oiseaux. C\'est, enfin, est-ce même de la viande tout court? Oh mon Dieu, c\'est comme de l\'encens! Ecoutez, laissez-moi sentir cette douce épice et je vous donnerai quelque chose en échange. Juste une petite bouffée, c\'est tout, je vais même payer pour ça.%SPEECH_OFF%Vous mettez la main sur votre épée.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Euh, d\'accord.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 66 ? "B" : "C";
					}

				},
				{
					Text = "Certainement pas.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Dancer != null)
				{
					this.Options.push({
						Text = "%bellydancer% la danseuse du ventre, vous connaissez cet homme?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Vous lui dites qu\'il peut prendre ce qu\'il désire, pourvu qu\'il vous paie à la fin. Il accepte et s\'approche en traînant les pieds, ses longs cerfs-volants suivant au-dessus comme des buses. Il se penche dans le chariot et renifle les alentours, son nez rouge et froid sifflant à chaque inspiration. Il arrive aux pots d\'encens et un sourire traverse son visage.%SPEECH_ON%Ah oui. Je n\'ai pas senti une telle magnificence depuis de très nombreuses années.%SPEECH_OFF%Il remonte sa veste et dépose une grande bourse de pièces sur le hayon de votre charriot. Vous les comptez, voyant que c\'est bien plus que ce que vous obtiendriez en vendant cet encens. Il se tourne vers vous, l\'encens serré dans ses bras.%SPEECH_ON%Marché conclu? %SPEECH_OFF%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un homme sait ce qu\'il aime.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local crowns = 0;
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						crowns = crowns + item.getValue() * 2;
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(crowns);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + crowns + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Vous retirez la main de votre épée et acceptez la proposition louche, bien qu\'apparemment inoffensive. Vous dites qu\'il peut avoir un aperçu de votre chariot s\'il paie d\'avance. L\'homme hoche la tête et donne quelques couronnes. Il met son nez bulbeux dans votre chariot, reniflant comme un cochon qui fouille le sol. Soudain, il attrape quelques pots d\'encens et arrache les couvertures. Toute la poussière et la poudre volent, l\'homme glousse et danse à travers. Vous allez pour l\'assommer, mais il vous lance tous les câbles de ses cerfs-volants, vous nouant dans leurs poignées filiformes. Tout en s\'échappant audacieusement, l\'étrange sihouette ricane tandis que l\'encens s\'échappe de ses épaules comme un passager errant qui passe un méridien céleste. Furieux, et vous détachant de ces maudits cerfs-volants, vous faites l\'inventaire des dégâts causés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est quoi ce bordel.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(15);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]15[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%bellydancer% la danseuse du ventre s\'avance, regarde dans la neige et, de manière plutôt inattendue, se demande à voix haute si c\'est son père. L\'homme fou s\'avance, ses cerfs-volants noirs le suivent comme des buses, puis son visage s\'illumine et les deux s\'embrassent. L\'homme est apparemment le père de %bellydancer% qu\'il avait perdu de vue, un marchand d\'encens qui s\'est dirigé vers le nord pour y être pris en embuscade et réduit en esclavage par les barbares sauvages auxquels il a échappé depuis. Il sourit éperdument. %SPEECH_ON%Il y avait si longtemps que je n\'avais pas vu de bon encens que je pouvais sentir ton chariot à des kilomètres. Ma femme, ta mère, %bellydancer%, comment va-t-elle? %SPEECH_OFF%Le sourire de la danseuse du ventre s\'efface. Il mentionne qu\'elle a gardé espoir aussi longtemps qu\'elle le pouvait. L\'homme acquiesce solennellement, mais aussi de manière attendue. Il dit qu\'il ne serait pas juste qu\'elle soit mariée à un spectre de ce qu\'elle a été, et que lui-même, sans espoir de retour, n\'est plus l\'ombre que de lui-même. L\'homme sort une arme ornée d\'une lame différente de tout ce que vous avez vu auparavant. Il dit qu\'il s\'agit d\'une relique familiale de longue date, et qu\'il l\'a gardée enterrée et en sécurité pendant toutes ses années dans le nord. %SPEECH_ON%Il vaut mieux que tu la prennes et que tu t\'en serves avant qu\'un des sauvages ici me mange et s\'en serve comme cure-dent. %SPEECH_OFF%L\'homme sourit affectueusement et les deux s\'embrassent un moment. Curieux, vous lui demandez pourquoi les cerfs-volants. Il répond que ce sont des outils de peur destinés à éloigner les animaux dangereux et autres, y compris les plus superstitieux des barbares. Vous dites au revoir à l\'homme et suggérez à %bellydancer% qu\'elle peut partir elle aussi si elle en a besoin, mais elle secoue la tête.%SPEECH_ON%La fille et le père ne doivent pas partager le chemin doré, car nous savons que nous serons ensemble à sa fin comme nous l\'étions à son début.%SPEECH_OFF%elle dit quelques mots à son père dans sa langue maternelle, puis les deux partent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon sang, cet encens est une bonne chose.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dancer.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_qatal_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Vous dites à l\'homme de s\'écarter, sinon... Il s\'exécute, bien qu\'il se tienne là, les deux mains tendues, les doigts s\'enfonçant dans l\'odeur que son nez a décelée. Vous jetez quelques regards en arrière, pour vous assurer qu\'il ne vous suit pas. Il se tient debout dans les étendues enneigées, fixant votre chariot. Il n\'est plus qu\'un éclat de noir. Puis il disparaît, ses cerfs-volants dansent au-dessus de lui puis ils disparaissent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne peux pas éviter ces étranges bâtards.",
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.incense")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() < 3)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_dancer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.belly_dancer")
			{
				candidates_dancer.push(bro);
			}
		}

		if (candidates_dancer.len() != 0)
		{
			this.m.Dancer = candidates_dancer[this.Math.rand(0, candidates_dancer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bellydancer",
			this.m.Dancer != null ? this.m.Dancer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dancer = null;
	}

});

